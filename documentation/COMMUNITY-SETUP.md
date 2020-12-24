# Setting up a Terrastories Community

## Table of Contents

1. [Why multi-instance architecture?](#why-multi-instance-architecture)

2. [Setting up communities](#setting-up-communities)

3. [Managing community users](#managing-community-users)

## Why multi-instance architecture?

Terrastories is built to host multiple communities with their own maps and stories on one Terrastories application. The communities' data is protected and accessible only through their own  user credentials, with different layers of permissions like viewing, editing, and changing settings for the whole community. 

Terrastories is set up in this way to enable multiple communities to leverage one hosting environment (online or offline) instead of having to set up a dedicated server, while retaining sovereignty over their data. In the future we will make it possible to enable selective sharing between communities across Terrastories, when desired.

Additionally, it may become beneficial in the future to integrate and create hooks for Terrastories with other third party platforms that serve multiple communities using user credentials in a similar way.

## Setting up communities

Terrastories has a special administrative user credential that has the power to create and modify communities. We call this `super admin`. When logged in as super admin, you are not able to access or modify any community's data or maps - this user credential is for the management of communities exclusively.

In the seed data that comes default with Terrastories, the default super admin credential is `super@terrastories.com` with password `terrastories`. When you install Terrastories for the first time, you can log in with this username to set up the communities you will be hosting. (There are two additional seed communities that come installed by default, `Terrastories` and `rfg`, which serve as examples and may be deleted.)

When you create a community as super admin, you will be required to specify an `admin` login. This `admin` credential serves that community exclusively, and has the power to create new users, edit the community theme, and add/modify stories and data.

## Managing community users

There are currently four types of Terrastories users at the community level:

1. `admin` - has permission to view, add, or modify `Stories`, `Speakers`, `Places` (restricted and non-restricted); add or modify `Users`; and change `Theme` settings.
2. `editor` - has the permission to view, add, or modify `Stories`, `Speakers`, and `Places` (restricted and non-restricted).
3. `member` - has the permission to view `Stories`, `Speakers`, and `Places` (restricted and non-restricted).
4. `viewer` - has the permission to view `Stories`, `Speakers`, and `Places` (non-restricted only).

The idea behind this architecture is to allow communities to determine who gets to edit manage the data, and who has access to restricted content. `members` can be understood as community members who can see all of the stories and places, whereas `viewers` are non-community members who may only see a selection of the stories that the community has chosen to share with outsiders.

It is in our roadmap to allow `admins` to set granulated viewing and editing permissions for each individual story per specific username credentials, instead of doing so on a binary community vs. outsider basis.