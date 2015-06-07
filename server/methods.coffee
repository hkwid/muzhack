logger = new Logger("methods")

getUser = (data) ->
  if !data.userId?
    throw new Error("You must be logged in to call this method")

  Meteor.users.findOne({_id: data.userId})

Meteor.methods({
  createProject: (id, title, tags, text) ->
    user = getUser(@)

    metadata = {
      owner: user.username,
      projectId: id,
      title: title,
      tags: tags,
      created: moment().utc().toDate(),
    }
    logger.info("Creating project #{user.username}/#{id}:", metadata)
    data = R.merge(metadata, {
      text: text,
    })
    Projects.insert(data)
  updateProject: (owner, id, title, description, instructions, tags, pictures) ->
    user = getUser(@)
    logger.debug("User #{user.username} updating project #{owner}/#{id}")
    logger.debug("Pictures:", pictures)
    Projects.update({owner: owner, projectId: id}, {$set: {
      title: title,
      text: description,
      instructions: instructions,
      tags: R.map(S.trim(null), tags.split(',')),
      pictures: pictures,
    }})
  removeProject: (id) ->
    user = getUser(@)

    project = Projects.findOne({projectId: id})
    if !project?
      return
    if project.owner != user.username
      throw new Meteor.Error("unauthorized", "Only the owner may remove a project")

    Projects.remove({projectId: id})
})
