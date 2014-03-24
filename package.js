Package.describe({
  summary: "Simple Markdown Editor"
});

Package.on_use(function(api){
  var both = ['client', 'server'];

  api.use([
    'coffeescript',
    'templating',
    'deps',
    'ace-embed',
    'marked',
    'less'
    ], 'client');

  // Client Files
  api.add_files([
    'client/markdown_editor.html',
    'client/markdown_editor.coffee',
    'client/handlebars_helper.coffee',
    'client/markdown.less'
  ], 'client');
});
