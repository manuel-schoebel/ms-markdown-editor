class @MarkdownEditor
  _deps: new Deps.Dependency
  state: 'write'
  editor: null
  setState: (value) ->
    return unless value isnt @state
    @state = value
    if @state is 'write'
      $('#markdown-editor').show()
      @editor.focus()
      $('#markdown-preview').hide()
    else
      $('#markdown-editor').hide()
      val = marked @editor.getValue()
      $('#markdown-preview').html(val).show()

    @_deps.changed()
  getState: ->
    @_deps.depend()
    return @state

  setEditor: (@editor) ->

  getValue: -> @editor.getValue()
  setValue: (value) -> @editor.setValue value

markdownEditor = markdownEditor or null;

Template.markdownEditor.created = ->
  markdownEditor = new MarkdownEditor()

Template.markdownEditor.rendered = ->
  editor = ace.edit 'markdown-editor'
  editor.setTheme 'ace/theme/chrome'
  editor.setFontSize 14
  editor.renderer.setShowPrintMargin false
  editor.renderer.setShowGutter false
  editor.setHighlightActiveLine true
  editor.getSession().setMode 'ace/mode/markdown'
  editor.getSession().setUseWrapMode true

  editor.on 'change', _.debounce((e) =>
    height = editor.getSession().getDocument().getLength() * editor.renderer.lineHeight + editor.renderer.scrollBar.getWidth()
    $('#markdown-editor').height height
    editor.resize()
  , 250)

  editor.focus()
  editor.getSelection().clearSelection()
  Deps.autorun -> editor.setValue(Session.get('markdownValue'))
  markdownEditor.setEditor(editor)

Template.markdownEditor.helpers({
  isActive: (state) ->
    return markdownEditor.getState() is state and markdownEditor
  getValue: ->
    markdownEditor.getValue() if markdownEditor
  setValue: (markdown) ->
    markdownEditor.setValue(markdown) if markdownEditor
})

Template.markdownEditor.events
  'click .toggle-editor': (evt, tpl) ->
    Etc.prevent(evt)
    state = $(evt.target).attr('data-value')
    markdownEditor.setState(state)
