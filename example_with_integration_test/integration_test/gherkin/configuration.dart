import 'package:example_with_integration_test/main.dart';
import 'package:example_with_integration_test/services/external_application_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:gherkin/gherkin.dart';

import 'hooks/reset_app_hook.dart';
import 'steps/expect_todos_step.dart';
import 'steps/multiline_string_with_formatted_json.dart';
import 'steps/when_await_animation.dart';
import 'steps/when_step_has_timeout.dart';
import 'world/custom_world.dart';

FlutterTestConfiguration gherkinTestConfiguration = FlutterTestConfiguration(
  tagExpression: '@debug',
  stepDefinitions: [
    thenIExpectTheTodos,
    whenAnAnimationIsAwaited,
    whenStepHasTimeout,
    givenTheData
  ],
  hooks: [
    ResetAppHook(),
  ],
  reporters: [
    StdoutReporter(MessageLevel.error)
      ..setWriteLineFn(print)
      ..setWriteFn(print),
    ProgressReporter()
      ..setWriteLineFn(print)
      ..setWriteFn(print),
    TestRunSummaryReporter()
      ..setWriteLineFn(print)
      ..setWriteFn(print),
  ],
  createWorld: (config) => Future.value(CustomWorld()),
);

Future<void> Function(World) appInitializationFn = (World world) async {
  // ensure a new injector instance is created each time
  final injector = Injector(DateTime.now().microsecondsSinceEpoch.toString());
  final externalApplicationManager = ExternalApplicationManager(injector);
  (world as CustomWorld)
      .setExternalApplicationManager(externalApplicationManager);

  runApp(
    TodoApp(
      injector: injector,
      externalApplicationManager: externalApplicationManager,
    ),
  );
};
