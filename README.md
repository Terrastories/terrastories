![Terrastories](https://www.amazonteam.org/wp-content/uploads/2018/09/logo-1170x164.png)

## Table of Contents

1. [About Terrastories](#about-terrastories)

2. [Install Terrastories](#install-terrastories)

3. [Setting up Communities and Users](#setting-up-communities-and-users)

4. [Customize Terrastories](#customize-terrastories)

5. [Demo and Tutorials](#demo-and-tutorials)

6. [Developing with Terrastories](#developing-with-terrastories)

7. [Contributing Guidelines](#contributing)

## About Terrastories

**Terrastories** is a geostorytelling application built to enable indigenous and other local communities to locate and map their own oral storytelling traditions about places of significant meaning or value to them. Community members can add places and stories through a user-friendly interface, and make decisions about designating certain stories as private or restricted. It is a dockerized Rails app that uses [**Mapbox**](https://mapbox.com) to help users locate content geographically on an interactive map. Terrastories is designed to be entirely offline-compatible, so that remote communities can access the application entirely without needing internet connectivity. 

The Terrastories interface is principally composed of an interactive map and a sidebar with media content. Users can explore the map and click on activated points to see the stories associated with those points. Alternatively, users can interact with the sidebar and click on stories to see where in the landscape these narratives took place. Through an administrative back end, users can also add, edit, and remove stories, or set them as restricted so that they are viewable only with a special login. Users can design and customize the content of the interactive map entirely, and the interface itself is customizable with a color scheme and design reflecting the style of the community.

Learn more about Terrastories at [https://terrastories.io/](https://terrastories.io/).

![](terrastories.gif)
###### *Terrastories: Matawai Konde 1.0 (October 2018)*

## Install Terrastories

Before you install Terrastories, you should consider the hosting environment for the application. Will it be hosted on an online server? If so, you are likely going to need to set up Terrastories on a Linux server. Are you installing Terrastories on your local machine, either for development or for demoing the app? Depending on what operating system you use, there are different setup guides, below. Lastly, if you are installing Terrastories to work fully offline (i.e. no online maps), there is a special guide for that use case as well.

To install and run a streamlined version of Terrastories with access to an online map on Mapbox.com, visit one of these links:
1. [Setup for Mac](documentation/SETUP-MAC.md)
2. [Setup for Windows](documentation/SETUP-WINDOWS.md)
3. [Setup for Linux](documentation/SETUP-LINUX.md)

To install and run Terrastories for offline "Field Kit" usage, visit:

4. [Setup for offline](documentation/SETUP-OFFLINE.md)

## Setting up Communities and Users

Terrastories is built to host multiple communities with their own maps and stories on one Terrastories application. The communities' data is protected and accessible only through their own  user credentials, with different layers of permissions like viewing, editing, and changing settings for the whole community. 

Terrastories is set up in this way to enable multiple communities to leverage one hosting environment (online or offline) instead of having to set up a dedicated server, while retaining sovereignty over their data. In the future we will make it possible to enable selective sharing between communities across Terrastories, when desired.

To learn how to set up Terrastories community instances and users, see our [community setup guide](documentation/COMMUNITY-SETUP.md).

## Customize Terrastories

To set up Terrastories with a custom map, languages, visual assets, and to import data, see our [customization guide](documentation/CUSTOMIZATION.md).

## Demo and Tutorials

In anticipation of the Terrastories technical session taking place at the 2020 Indigenous Mapping Workshop, we prepared three self-guided tutorials along with video walkthroughs per tutorial. We also put together a comprehensive video showing the application's core features, and a live demo to explore. 

These can be found on the [Terrastories website](https://terrastories.io/tutorials/).

## Developing with Terrastories

To find out how to develop with the Terrastories app, read our [developer guide](documentation/DEVELOPMENT.md) and check out our [Developer Community](https://terrastories.io/community/) pages on the Terrastories website.

For a general overview of the application as well as a Vision statement and Roadmap, please see our [Wiki](https://github.com/Terrastories/terrastories/wiki).

## Contributing

We ♥ contributors! By participating in this project, you agree to abide by the Ruby for Good [Code of Conduct](documentation/CODE_OF_CONDUCT.md).

**First:** if you're unsure or afraid of *anything*, just ask or submit the issue or pull request anyways. You won't be yelled at for giving your best effort. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contributions, and don't want a wall of rules to get in the way of that.

### How To Contribute To Terrastories

**Step 1: Learn a little about the app**
One of our core contributors @mirandawang wrote a really nice [outline of the app](https://docs.google.com/document/d/1azfvU7tXLv2EHGrc3Hs5SPmB32MkyYuhXTB4JjymlV4/edit). Unless you are working on something related to Docker containers or to map cartography then you will benefit from taking a couple minutes to get acquainted with the app. You can also check out our [roadmap](https://github.com/Terrastories/terrastories/wiki/Terrastories-Roadmap) to see where things are going with Terrastories development.

**Step 2: Find an issue to work on**
Please find an [issue](https://github.com/Terrastories/terrastories/issues) that you would like to take on and comment to assign yourself if no one else has done so already. All issues with the label `status: help wanted` are up for grabs! We will add the `status: claimed` label to the issue to mark it as assigned to you. Also, feel free to ask questions in the issues, and we will get back to you ASAP!

**Step 3: Fork the repo**
Click the "fork" button in the upper right of the Github repo page. A fork is a copy of the repository that allows you to freely explore & experiment without changing the original project. You can learn more about forking a repo in [this article](https://help.github.com/articles/fork-a-repo/).

**Step 4: Create a branch**
Checkout a new branch for your issue - this branch can be named anything, but we encourage the format  `XXX-brief-description-of-feature`  where  `XXX`  is the issue number.

**Step 5: Happy Hacking!**
Follow the instructions in the [Setup Document](#setup) to set up your local environment. Feel free to discuss any questions on the issues as needed, and we will get back to you! Don't forget to write some tests to verify your code. Commit your changes locally, using descriptive messages and please be sure to note the parts of the app that are affected by this commit.

**Step 6: Pushing your branch and creating a pull request**
Push your branch up and create a pull request! Please indicate which issue your PR addresses in the title.

### Code Reviews & Pull Request Merging
Once you've submitted a pull request, a core contributor will work with you on doing a code review (typically pretty minor unless it's a very significant PR). If the reviewer gives a ✅ to the PR merging, then huzzah! Merge into master! If your feature branch was in this main repository (and not forked), please delete your branch after it has been merged.

### Stay Scoped
Try to keep your PRs limited to one particular issue and don't make changes that are out of scope for that issue. If you notice something that needs attention but is out-of-scope, put a TODO, FIXME, or NOTE comment above it.

### Work In Progress Pull Requests
Sometimes we want to get a PR up there and going so that other people can review it or provide feedback, but maybe it's incomplete. This is OK, but if you do it, please tag your PR with an  `in-progress`  label so that we know not to review / merge it.

### Becoming a Core Steward
Users that are frequent contributors and are involved in discussion may be given direct Contributor access to the Repo so they can submit Pull Requests directly, instead of Forking first. You can join us in Slack [here](https://t.co/kUtI3lnpW1), and find us in the channel #terrastories! :) 
