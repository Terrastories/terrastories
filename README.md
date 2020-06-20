![Terrastories](https://www.amazonteam.org/wp-content/uploads/2018/09/logo-1170x164.png)

## Table of Contents

1. [About Terrastories](#about-terrastories)

2. [Setup Terrastories](#setup)

3. [Developing with Terrastories](#developing-with-terrastories)

4. [Contributing Guidelines](#contributing)

## About Terrastories

**Terrastories** is a geostorytelling application built to enable local communities to locate and map their own oral storytelling traditions about places of significant meaning or value to them. Community members can add places and stories through a user-friendly interface, and make decisions about designating certain stories as private or restricted. It is a dockerized Rails app that uses [**Mapbox**](https://mapbox.com) to help users locate content geographically on an interactive map. Terrastories is designed to be entirely offline-compatible, so that remote communities can access the application entirely without needing internet connectivity. 

If you'd like to learn more about the mission of Terrastories, read our [vision](VISION.md).

The Terrastories interface is principally composed of an interactive map and a sidebar with media content. Users can explore the map and click on activated points to see the stories associated with those points. Alternatively, users can interact with the sidebar and click on stories to see where in the landscape these narratives took place. Through an administrative back end, users can also add, edit, and remove stories, or set them as restricted so that they are viewable only with a special login. Users can design and customize the content of the interactive map entirely, and the interface itself is customizable with a color scheme and design reflecting the style of the community.

![](terrastories.gif)
###### *Terrastories: Matawai Konde 1.0 (October 2018)*

The project to develop this application was initiated by the [**Amazon Conservation Team**](http://amazonteam.org) (ACT), an organization who partners with indigenous and other traditional communities in the Amazon rainforest to help them protect their ancestral lands and traditional culture. The first version of the application was built for a Surinamese community called the Matawai, and is in a near-finalized state.

## Setup

To install and run Terrastories, visit one of these links:
1. [Setup for Mac](MAC.md)
2. [Setup for Windows](WINDOWS.md)
3. [Setup for Linux](Linux.md)

## Developing with Terrastories

To find out how to develop with the Terrastories app, click [here](DEVELOPMENT.md)

## Contributing

We ♥ contributors! By participating in this project, you agree to abide by the Ruby for Good [Code of Conduct](CODE_OF_CONDUCT.md).

**First:** if you're unsure or afraid of *anything*, just ask or submit the issue or pull request anyways. You won't be yelled at for giving your best effort. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contributions, and don't want a wall of rules to get in the way of that.

### How To Contribute To Terrastories

**Step 1: Learn a little about the app**
One of our core contributors @mirandawang wrote a really nice [outline of the app](https://docs.google.com/document/d/1azfvU7tXLv2EHGrc3Hs5SPmB32MkyYuhXTB4JjymlV4/edit). Unless you are working on something related to Docker containers or to map cartography then you will benefit from taking a couple minutes to get acquainted with the app. 

**Step 2: Find an issue to work on**
Please find an [issue](https://github.com/Terrastories/terrastories/issues) that you would like to take on and comment to assign yourself if no one else has done so already. All issues with the label `status: help wanted` are up for grabs! We will add the `status: claimed` label to the issue to mark it as assigned to you. Also, feel free to ask questions in the issues, and we will get back to you ASAP!

**Step 3: Fork the repo**
Click the "fork" button in the upper right of the Github repo page. A fork is a copy of the repository that allows you to freely explore & experiment without changing the original project. You can learn more about forking a repo in [this article](https://help.github.com/articles/fork-a-repo/).

**Step 4: Create a branch**
Checkout a new branch for your issue - this branch can be named anything, but we encourage the format  `XXX-brief-description-of-feature`  where  `XXX`  is the issue number.

**Step 5: Happy Hacking!**
Follow the instructions in the [Setup Document](SETUP.md) to set up your local environment. Feel free to discuss any questions on the issues as needed, and we will get back to you! Don't forget to write some tests to verify your code. Commit your changes locally, using descriptive messages and please be sure to note the parts of the app that are affected by this commit.

**Step 6: Pushing your branch and creating a pull request**
Push your branch up and create a pull request! Please indicate which issue your PR addresses in the title.

### Code Reviews & Pull Request Merging
Once you've submitted a pull request, a core contributor will work with you on doing a code review (typically pretty minor unless it's a very significant PR). If the reviewer gives a ✅ to the PR merging, then huzzah! Merge into master! If your feature branch was in this main repository (and not forked), please delete your branch after it has been merged.

### Stay Scoped
Try to keep your PRs limited to one particular issue and don't make changes that are out of scope for that issue. If you notice something that needs attention but is out-of-scope, put a TODO, FIXME, or NOTE comment above it.

### Work In Progress Pull Requests
Sometimes we want to get a PR up there and going so that other people can review it or provide feedback, but maybe it's incomplete. This is OK, but if you do it, please tag your PR with an  `in-progress`  label so that we know not to review / merge it.

### Becoming a Core Contributor
Users that are frequent contributors and are involved in discussion may be given direct Contributor access to the Repo so they can submit Pull Requests directly, instead of Forking first. You can join us in Slack [here](https://t.co/kUtI3lnpW1), and find us in the channel #terrastories! :) 
