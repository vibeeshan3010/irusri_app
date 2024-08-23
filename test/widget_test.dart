import 'package:eurovista/features/countryList/view/home.dart';
import 'package:eurovista/features/countryList/viewmodel/ApiViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';




class MockApiViewModel extends Mock implements ApiViewModel {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockApiViewModel mockApiViewModel;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockApiViewModel = MockApiViewModel();
    mockConnectivity = MockConnectivity();
  });

  testWidgets('displays no internet dialog when there is no connectivity', (WidgetTester tester) async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiViewModel>.value(value: mockApiViewModel),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("No Internet Connection"), findsOneWidget);
    expect(find.text("Please check your internet connection and try again."), findsOneWidget);
  });

  testWidgets('fetches data when there is internet connectivity', (WidgetTester tester) async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(mockApiViewModel.fetchData())
        .thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiViewModel>.value(value: mockApiViewModel),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    verify(mockApiViewModel.fetchData()).called(1);
  });

  testWidgets('displays loading indicator when data is being fetched', (WidgetTester tester) async {
    when(mockApiViewModel.isLoading).thenReturn(true);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiViewModel>.value(value: mockApiViewModel),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays no data available when there is no data', (WidgetTester tester) async {
    when(mockApiViewModel.isLoading).thenReturn(false);
    when(mockApiViewModel.data).thenReturn([]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiViewModel>.value(value: mockApiViewModel),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    expect(find.text('No data available'), findsOneWidget);
  });

  testWidgets('sorts countries by name when sort by name is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiViewModel>.value(value: mockApiViewModel),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    await tester.tap(find.text('Sort By Name'));
    await tester.pump();

    verify(mockApiViewModel.sortCountriesAlphabetically()).called(1);
  });
}
