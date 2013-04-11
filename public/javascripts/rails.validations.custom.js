clientSideValidations.validators.local["cannot_blank"] = function(element, options) {
  if (!i.test(element.val())) {
      return options.message;
    }
}}
