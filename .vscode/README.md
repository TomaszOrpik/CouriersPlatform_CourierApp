# Courier App

### Opis

Aplikacja androidowa służąca do wyświetlania domyślnej trasy kuriera, oraz śledzenia dostaw i aktualizowania statusu kuriera. Aplikacja pozwala na bezpośredni kontakt z odbiorcą przesyłki, śledzi pozycję kuriera oraz przekazuje dane o przesyłkach. Do działania aplikacji wymagany jest [Backend](https://dev.azure.com/tomaszorpik/Couriers%20Application/_git/Backend) oraz [Widget Mapy](https://dev.azure.com/tomaszorpik/Couriers%20Application/_git/MapView) w trybie produkcyjnym.

### Instalacja

- Przygotowanie mapy <br/>
  By uruchomić aplikację należy skompilować [Widget Mapy](https://dev.azure.com/tomaszorpik/Couriers%20Application/_git/MapView) w trybie produkcyjnym. Następnie skopiować zawartość folderu 'build' w folderze z widgetem do folderu 'assets/map_view'
- Instalacja Pakietów <br/>
   Instalujemy wszystkie niezbędne pakiety komendą `flutter pub get`.

### Wersja Developerska

- Aplikację uruchamiamy komendą `flutter run`

### Wersja Produkcyjna

- Przygotowanie Backendu
  Należy skompilować [Backend](https://dev.azure.com/tomaszorpik/Couriers%20Application/_git/Backend) w wersji produkcyjnej
- Przygotowanie zmiennych
  W pliku "constants.dart" w folderze "lib" podmieniamy adres backendu z adresem wersji produkcyjnej
- Skompilowanie aplikacji
  Aplikację kompilujemy do wersji produkcyjnej według [instrukcji](https://flutter.dev/docs/deployment/android).
