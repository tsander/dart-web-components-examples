import 'dart:html';
import 'package:web_ui/web_ui.dart';

class Tag {
  String additionalClass = "";
  String value;
  TagIt parent;
  Tag(this.value, this.parent, this.additionalClass);

  void removeTag(event) {
    parent.removeTag(this);
  }

  void onClick(event) {
    if (parent.onTagClicked != null) {
      parent.onTagClicked(this);
    }
  }
}

class TagIt extends WebComponent {
  List availableTags = [];
  // TODO(tsander): Use with autocomplete
  Function tagSource = null;

  bool caseSensitive = true;
  String placeholderText = "";

  // Allows for multi-word tags without using quotes.
  bool allowSpaces = false;

  String singleFieldDelimiter = ',';
  String initialValue = "";
  String newValue = "";
  List<Tag> values = [];

  // Event callbacks.
  Function onTagAdded = null;
  Function onTagRemoved = null;
  Function onTagClicked = null;

  String get value => Strings.join(assignedTags, singleFieldDelimiter);

  void tagSourceImpl(search, showChoices) {
    // TODO(tsander): implement
    // Get the lower case search term as filter
    // search all the available tags and see if it has an instance of the term
    // Finally show the choices (possible values - already chosen)
  }

  bool get clickable => onTagClicked != null;

  void onKeydown(KeyboardEvent event) {
    if (event.keyCode == KeyCode.BACKSPACE && newValue == "") {
      Tag tag = values.last;
      if (tag != null) {
        removeTag(tag);
      }
    }

    if (event.keyCode == KeyCode.COMMA
        || event.keyCode == KeyCode.ENTER
        || event.keyCode == KeyCode.TAB
        || (event.keyCode == KeyCode.SPACE && !allowSpaces 
            && !currentlyInQuotes())) {

      event.preventDefault();
      createTag(cleanedInput());
      // TODO(tsander): Close autocomplete
    }
  }

  bool currentlyInQuotes() {
    String input = newValue.trim();
    return input.length > 2
        && input.startsWith('"')
        && !(input.endsWith('"'));
  }

  void onBlur(event) {
    createTag(cleanedInput());
  }

  void inserted() {
    initialValue.split(singleFieldDelimiter).forEach((tag) => createTag(tag));
  }
  
  String cleanedInput() {
    RegExp trimRemoveQuotes = new RegExp(r'^"?\s*(.*?)\s*"?$');
    var m = trimRemoveQuotes.firstMatch(newValue);
    if (m == null) {
      return "";
    }
    newValue = m[1];
    return newValue;
  }

  List<String> get assignedTags => values.map((tag) => tag.value);

  String tagLabel(Tag tag) {
    return tag.value;
  }

  bool isNew(value) {
    return !values.some((tag) => value == tag.value);
  }

  String formatString(String value) {
    if (caseSensitive) {
      return value.trim();
    }
    return value.toLowerCase().trim();
  }

  void createTag(String value, [String additionalClass = ""]) {
    value = value.trim();
    
    // Check to see if we already have one??
    if (!isNew(value) || value == "") {
      return;
    }
    
    Tag tag = new Tag(value, this, additionalClass);
    if (onTagAdded != null) {
      onTagAdded(tag);
    }
    
    newValue = "";
    values.add(tag);
  }

  void removeTag(tag) {
    // Remove tag
    int index = values.indexOf(tag);
    if (index >= 0) {
      values.removeAt(index);
      if (onTagRemoved != null) {
        onTagRemoved(tag);
      }
    }
  }

  void removeAll() {
    List<Tag> copyOfValues = new List.from(values);
    copyOfValues.forEach((tag) => removeTag(tag));
  }

  // TODO(tsander): Port over JQuery autocomplete UI
}
