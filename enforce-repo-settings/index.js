const core = require('@actions/core');
const github = require('@actions/github');
const { Octokit } = require("@octokit/core");

const octokit = new Octokit({
  auth: core.getInput("api-token"),
});

/*
Ideen:
 - prüfen, ob für einzelne Repos Secrets gesetzt sind
 - Workflow-Dispatch für alle Repos ermöglichen
 - prüfen, ob der default_branch === main ist
 - prüfen, ob es leere Repos gibt
*/

const repoService = {
  getRepos: async () => {
    const { data: repos } = await octokit.request(
      "GET /orgs/{org}/repos?per_page={limit}",
      {
        org: "edact",
        limit: 100,
      }
    );

    return repos.filter((r) => {
      return Object.values({
        isRelevant: ["a3t", "f3t", "e3t", "i3t", "d3t"].some((prefix) =>
          r.name.startsWith(prefix)
        ),
        notArchived: !r.archived,
        // branch: r.default_branch != "main",
        // size: r.size < 10,
      }).every((condition) => condition == true);
    });
  },

  enforceRepoSettings: async (repo) => {
    await octokit.request("PATCH /repos/{owner}/{repo}", {
      owner: repo.owner.login,
      repo: repo.name,
      has_issues: false,
      has_projects: false,
      has_wiki: false,
      allow_squash_merge: true,
      allow_merge_commit: false,
      allow_rebase_merge: false,
      delete_branch_on_merge: true,
    });
  },

  enableRepoDependabot: async (repo) => {
    await octokit.request("PUT /repos/{owner}/{repo}/vulnerability-alerts", {
      owner: repo.owner.login,
      repo: repo.name,
      mediaType: {
        previews: ["dorian"],
      },
    });

    await octokit.request(
      "PUT /repos/{owner}/{repo}/automated-security-fixes",
      {
        owner: repo.owner.login,
        repo: repo.name,
        mediaType: {
          previews: ["london"],
        },
      }
    );
  },

  enforceRepoBranchProtection: async (repo) => {
    const { data: branch } = await octokit.request(
      "GET /repos/{owner}/{repo}/branches/{branch}",
      {
        owner: repo.owner.login,
        repo: repo.name,
        branch: repo.default_branch,
      }
    );

    await octokit.request(
      "PUT /repos/{owner}/{repo}/branches/{branch}/protection",
      {
        mediaType: {
          previews: ["luke-cage"],
        },
        owner: repo.owner.login,
        repo: repo.name,
        branch: repo.default_branch,
        required_status_checks: {
          strict: true,
          contexts: branch.protection
            ? branch.protection.required_status_checks.contexts
            : [],
        },
        enforce_admins: true,
        required_pull_request_reviews: {
          dismissal_restrictions: {},
          dismiss_stale_reviews: true,
          require_code_owner_reviews: false,
          required_approving_review_count: 1,
        },
        restrictions: null,
      }
    );
  },
};

try {
  (async () => {
  
    const repos = await repoService.getRepos();

    console.log(">>", repos.length, "Repos");

    await Promise.all([
      ...repos.map(async (r) => repoService.enforceRepoSettings(r)),
      ...repos.map(async (r) =>
        repoService.enforceRepoBranchProtection(r)
      ),
      ...repos.map(async (r) =>
        repoService.enableRepoDependabot(r)
      ),
    ]);
})();
  } catch (err) {
    console.error(err);
  }
