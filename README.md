# 📦 Product Manager — Laravel + Inertia.js + Vue 3

Aplikacja webowa typu SPA (Single Page Application) do zarządzania produktami, zbudowana w oparciu o nowoczesny stack technologiczny. Projekt demonstruje umiejętność łączenia backendu Laravel z frontendowym Vue 3 przy użyciu Inertia.js jako mostu między nimi — bez potrzeby budowania osobnego REST API.

---

## 🧰 Stack technologiczny

- **PHP 8.3** — backend
- **Laravel 12** — framework backendowy (routing, ORM, walidacja, autoryzacja)
- **Inertia.js 2** — most między Laravel a Vue, eliminuje potrzebę REST API
- **Vue 3** — reaktywny frontend z Composition API i `<script setup>`
- **Tailwind CSS** — stylowanie utility-first
- **Vite** — bundler i dev server
- **MySQL** — baza danych
- **Laravel Breeze** — starter kit do autentykacji

---

## ✨ Funkcjonalności

- Rejestracja i logowanie użytkowników (Laravel Breeze)
- Każdy użytkownik widzi i zarządza wyłącznie swoimi produktami (izolacja danych)
- Pełny CRUD produktów (Create, Read, Update, Delete)
- Paginacja listy produktów (10 produktów na stronę)
- Wyszukiwanie produktów po nazwie lub kategorii w czasie rzeczywistym
- Sortowanie kolumn (nazwa, cena, waga) rosnąco i malejąco
- Zaznaczanie wielu produktów i operacje masowe (bulk delete, bulk edit kategorii)
- Walidacja formularzy po stronie serwera z komunikatami błędów
- Powiadomienia toast po operacjach (dodanie, edycja, usunięcie)
- Cena przechowywana w groszach (integer) i automatycznie przeliczana przy wyświetlaniu

---

## 📋 Wymagania systemowe

Przed instalacją upewnij się że masz zainstalowane:

- PHP >= 8.2 z rozszerzeniami: `pdo`, `pdo_mysql`, `mbstring`, `xml`, `curl`
- Composer >= 2.x
- Node.js >= 18.x
- npm >= 9.x
- MySQL >= 8.0 (lub MariaDB >= 10.6)

---

## 🚀 Instalacja krok po kroku

### 1. Sklonuj repozytorium

```bash
git clone https://github.com/twoj-username/spa_inertia.git
cd spa_inertia
```

### 2. Zainstaluj zależności PHP

```bash
composer install
```

### 3. Skopiuj plik konfiguracyjny środowiska

```bash
cp .env.example .env
```

### 4. Wygeneruj klucz aplikacji

```bash
php artisan key:generate
```

### 5. Skonfiguruj bazę danych

Otwórz plik `.env` i uzupełnij dane dostępowe do swojej bazy MySQL:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=spa_inertia
DB_USERNAME=root
DB_PASSWORD=twoje_haslo
```

Następnie utwórz bazę danych w MySQL i uruchom migracje:

```bash
php artisan migrate
```

### 6. (Opcjonalnie) Wypełnij bazę danymi testowymi

Projekt zawiera gotowe seedery które tworzą 5 użytkowników testowych, 10 kategorii oraz po 30 produktów dla każdego użytkownika:

```bash
php artisan db:seed
```

### 7. Zainstaluj zależności JavaScript

```bash
npm install
```

### 8. Uruchom aplikację

W środowisku deweloperskim uruchom oba serwery jednocześnie (Laravel i Vite):

```bash
# Sposób 1 — wszystko w jednym poleceniu (zalecane)
composer run dev

# Sposób 2 — w dwóch osobnych terminalach
php artisan serve    # terminal 1
npm run dev          # terminal 2
```

Aplikacja będzie dostępna pod adresem **http://127.0.0.1:8000**

---

## 🗂️ Struktura projektu

Poniżej znajdziesz opis najważniejszych folderów i plików projektu — co się w nich znajduje i do czego służą.

### `app/`

Serce aplikacji — cały kod PHP backendowy.

`app/Http/Controllers/` — kontrolery obsługujące żądania HTTP. Każda akcja użytkownika (wejście na stronę, zapis formularza, usunięcie rekordu) trafia najpierw tutaj. Projekt zawiera `ProductController` z metodami CRUD oraz metodami do operacji masowych (`bulkUpdate`, `bulkDestroy`), a także `ProfileController` do zarządzania profilem użytkownika.

`app/Http/Requests/` — klasy walidujące dane przychodzące z formularzy zanim trafią do kontrolera. `StoreProductRequest` i `UpdateProductRequest` definiują reguły dla danych produktu, `BulkUpdateProductRequest` waliduje masową edycję. Dzięki temu kontrolery pozostają czyste — nie ma w nich logiki walidacji.

`app/Http/Resources/` — klasy transformujące modele Eloquent na format JSON wysyłany do frontendu. `ProductResource` i `CategoryResource` precyzyjnie kontrolują które pola są widoczne po stronie Vue — to ważne dla bezpieczeństwa i spójności API.

`app/Models/` — modele Eloquent reprezentujące tabele bazy danych. `Product` zawiera relacje do `User` i `Category`, a także Accessor/Mutator do automatycznego przeliczania ceny (przechowywana w groszach × 100, wyświetlana po podzieleniu). `User` ma relację `hasMany` do produktów.

`app/Policies/` — klasy autoryzacji kontrolujące kto może wykonać daną akcję na modelu. `ProductPolicy` zapewnia że użytkownik może operować tylko na swoich produktach.

### `database/`

`database/migrations/` — pliki definiujące strukturę tabel bazy danych w PHP, zamiast pisania SQL ręcznie. Każda migracja ma metodę `up()` (tworzenie) i `down()` (cofanie). Projekt zawiera migracje dla tabel: `users`, `categories`, `products`, a także standardowych tabel Laravel: `sessions`, `cache`, `jobs`.

`database/seeders/` — klasy wypełniające bazę danymi testowymi. `DatabaseSeeder` używa fabryk do wygenerowania realistycznych danych: 10 kategorii, 5 użytkowników, każdy z 30 losowymi produktami.

`database/factories/` — fabryki generujące losowe dane testowe przy użyciu biblioteki Faker (losowe nazwy produktów, ceny, opisy itp.).

### `resources/`

`resources/js/Pages/` — strony Vue renderowane przez Inertia.js. Każdy plik odpowiada jednej "stronie" aplikacji. Folder `Product/` zawiera: `Index.vue` (lista produktów z wyszukiwaniem, sortowaniem i checkboxami), `Create.vue` (formularz tworzenia), `Edit.vue` (formularz edycji), `Show.vue` (widok szczegółów), `BulkEdit.vue` (modal do masowej edycji), `ProductForm.vue` (współdzielony komponent formularza).

`resources/js/Components/` — wielokrotnie używane komponenty Vue. Znajdują się tu m.in. `Pagination.vue` (nawigacja stron), `Sortable.vue` (nagłówki kolumn z sortowaniem), `Checkbox.vue` i `CheckAll.vue` (checkboxy do zaznaczania produktów), `Modal.vue` (okno modalne), `toast/` (powiadomienia po operacjach).

`resources/js/Layouts/` — układy stron (layouty). `AuthenticatedLayout.vue` to główny layout dla zalogowanych użytkowników — zawiera nawigację, header i slot na treść strony.

`resources/views/` — jedyny plik Blade to `app.blade.php`, który jest punktem wejścia całej aplikacji SPA. Inertia.js renderuje tu swój root div, a Vue przejmuje kontrolę nad resztą interfejsu.

### `routes/`

`routes/web.php` — definicje wszystkich ścieżek URL aplikacji. Trasy dla produktów są zgrupowane pod middleware `auth` (wymagają zalogowania). Projekt używa `Route::resource()` do automatycznego generowania 7 standardowych tras CRUD, plus ręcznie zdefiniowane trasy dla operacji masowych.

### `config/`

Pliki konfiguracyjne Laravel — baza danych, cache, sesje, mail itp. W większości przypadków nie wymagają modyfikacji, bo wartości czytane są z pliku `.env`.

---

## 🔐 Domyślne konta testowe (po uruchomieniu seedera)

Seeder tworzy 5 losowych użytkowników. Możesz sprawdzić ich dane w bazie lub zarejestrować własne konto przez formularz rejestracji dostępny na stronie głównej.

---

## 🏗️ Architektura — jak to działa razem

Projekt używa wzorca **Inertia.js**, który jest alternatywą dla klasycznego podejścia SPA z REST API. Zamiast budować osobne API i odpytywać je przez `fetch()` lub `axios`, kontrolery Laravel zwracają komponenty Vue z danymi — dokładnie tak jak normalnie zwracałyby widoki Blade, ale zamiast HTML dostają strony Vue.

Przepływ danych wygląda następująco: przeglądarka wysyła żądanie → Laravel router kieruje je do odpowiedniego kontrolera → kontroler pobiera dane z bazy przez Eloquent → dane przechodzą przez Resource (transformacja JSON) → Inertia wysyła komponent Vue z danymi jako propsy → Vue renderuje interfejs w przeglądarce.

Gdy użytkownik klika link lub wysyła formularz, Inertia przechwytuje żądanie i zamiast pełnego przeładowania strony wykonuje żądanie XHR — co daje efekt SPA (płynna nawigacja bez migotania) przy prostocie klasycznej aplikacji Laravel.

---

## 📦 Przydatne komendy

```bash
# Uruchomienie środowiska deweloperskiego
composer run dev

# Zbudowanie assets produkcyjnych
npm run build

# Uruchomienie migracji
php artisan migrate

# Cofnięcie wszystkich migracji i ponowne uruchomienie z seederem
php artisan migrate:fresh --seed

# Uruchomienie testów
composer run test

# Formatowanie kodu PHP (Laravel Pint)
./vendor/bin/pint
```