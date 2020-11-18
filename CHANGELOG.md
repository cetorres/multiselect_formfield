
## [0.1.5] - 11/18/2020

* UI improvements:
  * Add an enabled status to the multiselect.

Thanks to [Ali Briceño](https://github.com/alienriquebm). Merged pull request [#12](https://github.com/cetorres/multiselect_formfield/pull/12).

## [0.1.4] - 09/21/2020

* Added more UI features:
  * Title/Hint as Widget.
  * Chip customizations(color/label).
  * Dialog customizations - Dialog textStyle.
  * View updated README for more details.

Thanks to [Suraj Lad](https://github.com/SurajLad). Merged pull request [#25](https://github.com/cetorres/multiselect_formfield/pull/25).
  
## [0.1.3] - 05/07/2020

* Bugfix: When providing default value on load the validator is always null
  * Removed all intellij files and .gitignored. This seems to be recommended. Also .gitignored some files that were auto generated in my project for iOS.
  * Fixed a warning with the validator that said you must always return something. Returning null is the proper thing to return if passed validation: https://flutter.dev/docs/cookbook/forms/validation.
  * BREAKING CHANGE. Removed value. Seems like its more standard to have initialValue. Replaced value for the built in state.value. In which initialvalue automatically sets state.value as seen in https://github.com/flutter/flutter/blob/e0c63cd35e15e407a80dc44281cc392535fcce25/packages/flutter/lib/src/widgets/form.dart#L422.

Thanks to [David Corrado](https://github.com/DavidCorrado).

## [0.1.2] - 09/27/2019

* Changed README.

## [0.1.1] - 03/25/2019

* Fixed README.
  
## [0.1.0] - 03/25/2019

* First release.
