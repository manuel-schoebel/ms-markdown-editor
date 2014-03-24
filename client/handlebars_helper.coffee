Helpers =
  renderMarkdown: () ->
    return marked @markdown if marked and @markdown

for name, func of Helpers
  Handlebars.registerHelper name, func
