import 'package:eurovista/features/countryList/viewmodel/ApiViewModel.dart';
import 'package:mockito/annotations.dart';


@GenerateMocks([ApiViewModel])
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'widget_test.dart';


@GenerateMocks([Connectivity, ApiViewModel])
void main() {
  late MockConnectivity mockConnectivity;
  late MockApiViewModel mockApiViewModel;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockApiViewModel = MockApiViewModel();
  });

  testWidgets('fetches data when there is internet connectivity', (WidgetTester tester) async {
    // Arrange: Set up the mock to return ConnectivityResult.wifi
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(mockApiViewModel.fetchData()).thenAnswer((_) async {});

    // Act: Build the widget and trigger the checkConnectivity call

    // Assert: Verify fetchData was called
    verify(mockApiViewModel.fetchData()).called(1);
  });
}
