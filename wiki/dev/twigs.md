# Branches and Twigs

## Twigs

* Relatively short-lived
* Share the commit policy of their parent branch
* Gain little value from global names
* Examples: most "topic branches" are twigs

## Branches

* Relatively long-lived
* Correspond to differences in commit policy
* Gain lots of value from global names
* Examples: git-flow 'master', 'develop', &amp;c; hg 'stable' vs 'default';
  release branches

## Commit policy

* Decisions like "should every commit pass tests?" and "is rewriting or
  deleting a commit acceptable?" are, collectively, the policy of a branch
* Can be very formal or even tool-enforced, or ad-hoc and fluid
* Shared understanding of commit policy helps get everyone's expectations
  lined up, easing other SCM-mediated conversations
