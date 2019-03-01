![Terrastories](https://www.amazonteam.org/wp-content/uploads/2018/09/logo-1170x164.png)

**TerraStories** is an application designed to help communities map and access their own place-based storytelling. The project to develop this application was initiated by the [**Amazon Conservation Team**](http://amazonteam.org) (ACT), an organization who partners with indigenous and other traditional communities in the Amazon rainforest to help them protect their ancestral lands and traditional culture. The application is developed to be entirely open source and offline-compatible, so that it can be used by communities in the most remote locations of the world. It is a Dockerized Rails App that uses [**Mapbox**](https://mapbox.com) to help users locate content geographically on an interactive map. A team is attempting to finish this app at **Ruby by the Bay 2019**: https://rubybythebay.org/ and **Ruby for Good 2019**: http://rubyforgood.org/2019

## How to Contribute
We ♥ contributors! By participating in this project, you agree to abide by the Ruby for Good [Code of Conduct](CODE_OF_CONDUCT.md). We welcome all types of contributions, but any pull requests that address open issues, have test coverage, or are tagged with the next milestone will be prioritized.

**First:** if you're unsure or afraid of *anything*, just ask or submit the issue or pull request anyways. You won't be yelled at for giving your best effort. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contributions, and don't want a wall of rules to get in the way of that.

## Steps to Contribute to Terrastories
**Step 1: Find an issue to work on**
Visit our [issues page](https://github.com/rubyforgood/terrastories/network/members) and find an issue you'd like to work on that hasn't already been claimed (It has been claimed if you see someone else's picture on it and it is assigned to someone else, or if you see someone's comment on the issue page saying they are claiming it). Comment on the issue that you have claimed it and will be working on it. An admin will add you as the assignee. 

**Step 2: Fork the repo**
Click the "fork" button in the upper right of the Github repo page. A fork is a copy of the repository that allows you to freely explore & experiment without changing the original project. You can learn more about forking a repo in [this article](https://help.github.com/articles/fork-a-repo/).

**Step 3: Create a branch**
Checkout a new branch for your issue - this branch can be named anything, but we encourage the format  `XXX-brief-description-of-feature`  where  `XXX`  is the issue number.

**Step 4: Happy Hacking!**
Follow the instructions in the [SETUP.md](SETUP.md) to set up your local environment. Feel free to discuss any questions on the issues as needed, and we will get back to you! Don't forget to write some tests to verify your code. Commit your changes locally, using descriptive messages and please be sure to note the parts of the app that are affected by this commit.

**Step 5: Pushing your branch and creating a pull request**
Make sure the tests pass! Run the current test suite with `docker-compose exec rails bundle exec rake test` If any tests break, be sure to fix them. Make a final commit if you've made more changes to fix the tests. Then, push your branch up and create a pull request. Please indicate which issue your PR addresses in the title.

## Squashing Commits
Squashing your own commits before pushing is totally fine. Please don't squash other people's commits. (Everyone who contributes here deserves credit for their work! :) ). Also, consider the balance of "polluting the git log with commit messages" vs. "providing useful detail about the history of changes in the git log". If you have several (or many) smaller commits that all serve one purpose, and these can be squashed into a single commit whose message describes the thing, you're encouraged to squash.

There's no hard and fast rule here about this (for now), just use your best judgement.

## Code Reviews & Pull Request Merging
Once you've submitted a pull request, a core contributor will work with you on doing a code review (typically pretty minor unless it's a very significant PR). If the reviewer gives a ✅ to the PR merging, then huzzah! Merge into master! If your feature branch was in this main repository (and not forked), please delete your branch after it has been merged.

## Stay Scoped
Try to keep your PRs limited to one particular issue and don't make changes that are out of scope for that issue. If you notice something that needs attention but is out-of-scope, put a TODO, FIXME, or NOTE comment above it.

## Technical Spike / Investigation Issues
These issues will have an `investigation` label attached to them. They are unique in that we do not have the full details on how to solve the actual issue. These are issues that require some investigation and digging into the technology to figure out the solution. What we expect to come out of these issues is a quick write up about what you were able to find in your research. This will help inform and create new issues that are better defined and have specific steps to solve the original problem. 

## Work In Progress Pull Requests
Sometimes we want to get a PR up there and going so that other people can review it or provide feedback, but maybe it's incomplete. This is OK, but if you do it, please tag your PR with an  `in-progress`  label so that we know not to review / merge it.

## Becoming a Core Contributor
Users that are frequent contributors and are involved in discussion may be given direct Contributor access to the Repo so they can submit Pull Requests directly, instead of Forking first. You can join us in Slack [here](https://t.co/kUtI3lnpW1), and find us in the channel #terrastories! :)
