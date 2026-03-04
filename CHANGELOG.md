# appcraft_ui_calendar_flutter

<!--
Шаблон для будущих версий CHANGELOG.md:
## <version>

- Краткое описание изменений (императивный стиль, настоящее время).
- Список ключевых изменений:
  - Что добавлено.
  - Что изменено.
  - Что исправлено.
  - Что удалено или устарело.
- Каждое изменение — отдельный пункт, без лишних деталей реализации.
-->

## 0.0.21

- `ACCalendarRepository` становится абстрактным; реализация вынесена в `ACDefaultCalendarRepository` — параметр `weekStart` перенесён в конструктор репозитория.
- `ACVerticalCalendarWidget` переименован в `ACCalendarWidget`.
- `ACCalendarCard` переименован в `ACPagesCalendarCard`; параметр `weekStart` удалён.
- `ACDayWidget` перенесён в модуль `day`; добавлен `ACCalendarDayWidget`.
- `ACCalendarScope` принимает `repository` для передачи репозитория вниз по дереву виджетов.
- `ACWeekWidget`, `ACMonthPicker`, `ACPagesCalendarWidget`, `ACCalendarScreen`: параметр `weekStart` заменён на `repository`.

## 0.0.20

- Исправлено отображение выбора дат в `ACDayWidget`: вычисление состояния выбора перенесено внутрь `ListenableBuilder`.
- `ACTimeRangeInputController`: метод `_validateAndCorrect` разделён на `_correctMax` и `_correctMin` с защитой от рекурсии.
- `ACDayThemeData`: изменён цвет фона выбранного дня на более мягкий (`0xFFD2DCFF`).
- `ACCalendarScreen`: убран отступ заголовка в `AppBar` (`titleSpacing: 0`).
- Добавлено демо-приложение с меню: секции `ACCalendarScreen` и `ACCalendarCard` с вариантами выбора дат (Single, Range, Multi).

## 0.0.19

- `ACCalendarScreen`: тап по году открывает `ACMonthPickerSheet` с навигацией к выбранному месяцу; заголовок обновляется при прокрутке.
- `ACVerticalCalendarWidget`: добавлен параметр `scrollViewController` для передачи внешнего контроллера прокрутки.
- `ACMonthPickerSheet`: добавлена локализация заголовка и кнопки «Готово»; body обёрнут в `SafeArea`.
- `ACTitledTimeWidget`: заголовок «Время» берётся из локализации.
- `ACScrollViewController`: `_dataSource` больше не nullable — используется `_EmptyDataSource` как начальное значение; слушатель прокрутки подключается в конструкторе.

## 0.0.18

- Добавлен `ACCalendarCard` — карточка с `ACPagesCalendarWidget` внутри декорированного контейнера; принимает `padding`, `decoration`, `borderRadius`, `backgroundColor`.
- Добавлен `ACCalendarScreen` — полноэкранный экран с `ACVerticalCalendarWidget` и `AppBar`, отображающим актуальный год; год обновляется при прокрутке; поддерживает `titleColor`, `titleTextStyle`, `backgroundColor`; тап по году открывает `ACMonthPickerSheet`.
- Добавлен `ACMonthPickerSheet` — нижний лист с `ACMonthPicker`; содержит кнопку «Готово» в `AppBar`; поддерживает `onDone(DateTime)` и статический метод `ACMonthPickerSheet.show(...)`.
- `ACVerticalCalendarWidget`: добавлен `ACWeekWidget` над лентой месяцев.
- `ACVerticalCalendarWidget`: добавлены параметры `timeWidget`, `scrollViewPadding`, `weekPadding`, `timeWidgetPadding`.
- `ACMonthPicker` перемещён в отдельный модуль `month_picker`.

## 0.0.17

- Добавлен `ACTimeInputWidget` — виджет ввода времени с маской `HH:MM`, посимвольной валидацией (часы 00–23, минуты 00–59) и `ACTimeInputController`.
- Добавлен `ACTimeRangeInputWidget` — виджет ввода диапазона времени из двух `ACTimeInputWidget` с разделителем; при незаданном контроллере создаёт внутренний автоматически.
- Добавлен `ACTimeRangeInputController` — контроллер диапазона времени с автокоррекцией: если конец раньше начала, конец устанавливается равным началу.
- Добавлен `ACTitledTimeWidget` — виджет с заголовком и полем ввода времени; именованные конструкторы `.single` и `.range`; реализует `PreferredSizeWidget`.
- Добавлена доменная модель `ACTimeSelectRange` (start/end как `TimeOfDay?`) по аналогии с `ACDateSelectRange`.
- Добавлены темы `ACTimeInputThemeData` и `ACTitledTimeThemeData`; зарегистрированы в `ACCalendarThemeData`.
- `ACPagesCalendarWidget`: добавлен параметр `timeWidget` (`PreferredSizeWidget?`) — виджет под сеткой дат с автоматическим расчётом высоты.
- `ACDateSelectRange`: добавлен assert `end >= start` в конструкторе.

## 0.0.16

- `ACScrollView`: добавлен параметр `spacing` — расстояние между элементами списка.
- `ACScrollView`: `padding` корректно применяется через `SliverPadding` с разделением на cross-axis и main-axis отступы.
- `ACScrollViewDataSource`: добавлены геттеры `reachedEndBefore` и `reachedEndAfter` — признаки достижения края данных в каждом направлении.
- `ACDefaultScrollViewDataSource`: прекращает подгрузку элементов при достижении края данных.
- `ACScrollViewController`: расчёт смещений и позиций учитывает `spacing` между элементами.

## 0.0.15

- `ACScrollViewDataSource.currentItem` теперь `T?` — возвращает `null` вместо `RangeError` при обращении к неинициализированному источнику данных.
- `shouldBefore`, `shouldAfter`, `loadBefore`, `loadAfter` корректно обрабатывают `null`-состояние `currentItem`.
- `ACScrollViewController`: `_onScroll` и `_notifyVisibleItemChanged` безопасно обрабатывают nullable `currentItem`.

## 0.0.14

- Добавлен абстрактный `ACScrollViewDataSource<T>` — контракт источника данных для `ACScrollView`: `beforeItems`, `afterItems`, `currentItem`, `currentIndex`, `shouldBefore`, `shouldAfter`, `initialize()`, `loadMore()`, `setCurrentIndex()`, `loadBefore()`, `loadAfter()`.
- Добавлена реализация `ACDefaultScrollViewDataSource<T>`: управление списками элементов, индексом, пороговой подгрузкой (`bufferThreshold`, `preloadCount`); принимает колбэки `onBefore`/`onAfter` для генерации элементов.
- `ACScrollView` принимает `dataSource: ACScrollViewDataSource<T>` вместо `initialItem`, `onBefore`, `onAfter`, `bufferThreshold`, `preloadCount` — данные и логика подгрузки полностью делегированы `dataSource`.
- `ACScrollViewController`: добавлены `attachDataSource()`, `getExtent()` (кэш extent'ов), `jumpToItem()`, `animateToBeforeItem()`, `animateToAfterItem()`, `updateScrollState()`; удалены `pendingJumpItem`, `pendingBeforeCommand`, `pendingAfterCommand`, `ACScrollViewAnimateCommand` — паттерн команд заменён прямыми вызовами.
- `ACScrollView` (state): упрощён — слушает `dataSource` и `controller`, отслеживает `_lastCurrentItem` для `onVisibleItemChanged`; вся навигация делегирована контроллеру.
- `ACPagesCalendarWidget`, `ACVerticalCalendarWidget`: контроллер и `dataSource` создаются в `initState`; при изменении `range` вызывается `jumpToItem` (замыкания `onBefore`/`onAfter` захватывают `_range` через `this`).

## 0.0.13

- Рефакторинг `ACScrollView`: данные (`beforeItems`, `afterItems`, логика подгрузки) перенесены из контроллера в стейт виджета.
- `ACScrollView` получил новые обязательные параметры: `initialItem`, `onBefore`, `onAfter`, `itemExtentBuilder`; опциональные: `onVisibleItemChanged`, `bufferThreshold`, `preloadCount`.
- `ACScrollViewController` упрощён до навигационного контроллера: содержит `currentItem`, `shouldBefore`, `shouldAfter`, `animateToBeforeItem`, `animateToAfterItem`, `jumpToItem`; общается со стейтом виджета через паттерн команд.
- Удалены `ACDefaultScrollViewController`, `ACDateRangeScrollViewController`, `ACScrollViewChildDelegate`.

## 0.0.12

- Добавлена `ACMonthPickerThemeData` — тема для `ACMonthPicker` с полем `selectionColor` (цвет подсветки выбранной строки).
- Добавлена `ACWheelPickerThemeData` — тема для `ACWheelPicker` с полями `itemTextColor`, `selectedItemTextColor`, `itemTextStyle`; заменяет удалённую `ACWheelThemeData`.
- Удалена `ACWheelThemeData`.
- `ACCalendarThemeData`: поле `wheelTheme: ACWheelThemeData` заменено на `wheelPickerTheme: ACWheelPickerThemeData` и `monthPickerTheme: ACMonthPickerThemeData`; удалено поле `accentColor`.
- `ACWheelPicker` переведён на `ACWheelPickerThemeData`; тема берётся из `ACCalendarTheme.of(context).wheelPickerTheme`.
- `ACMonthPicker`: поле `theme: ACCalendarThemeData?` разделено на `monthPickerTheme: ACMonthPickerThemeData?` и `wheelPickerTheme: ACWheelPickerThemeData?`; `selectionColor` контейнера берётся из `monthPickerTheme`.
- `ACDayWidget`: удалены пропы `backgroundColor`, `textColor`, `textStyle`, `decoration`, `padding`, `shape`, `text` — все значения берутся из темы или захардкожены внутри виджета.

## 0.0.11

- Добавлена `ACPagesCalendarHeaderThemeData` — отдельная тема для `ACPagesCalendarHeader` с полями `arrowColor` (цвет стрелок навигации), `monthTextColor` (цвет текста месяца и иконки-дропдауна) и `titleTextStyle`.
- `ACCalendarThemeData` и `ACLightCalendarThemeData`: поле `calendarHeaderTheme: ACCalendarHeaderThemeData` заменено на `pagesCalendarHeaderTheme: ACPagesCalendarHeaderThemeData`.
- `ACPagesCalendarHeader` переведён на `ACPagesCalendarHeaderThemeData`; единый `primaryColor` разделён на `arrowColor` и `monthTextColor`.

## 0.0.10

- Удалён `ACVerticalCalendarChildDelegate` и `ACDefaultVerticalCalendarChildDelegate`: логика кэширования, компоновки и построения месяца инлайнена в `ACVerticalCalendarWidget`; параметр `layout` заменён на `weekStart`.
- `ACVerticalCalendarWidget` приведён в соответствие с `ACPagesCalendarWidget`: добавлены `_range`, `_initialMonth`, `_currentMonth` в стейт; контроллер прокрутки создаётся лениво и пересоздаётся при изменении диапазона или `weekStart`; добавлен `dispose`.
- Удалён `ACPagesCalendarChildDelegate` и `ACDefaultPagesCalendarChildDelegate`: логика инлайнена в `ACPagesCalendarWidget`; убран параметр `childDelegate`.
- Удалён `ACMonthChildDelegate` и все подклассы (`ACDaysMonthChildDelegate`, `ACDefaultDaysMonthChildDelegate`, `ACCustomDaysMonthChildDelegate`): логика построения дней инлайнена в `ACMonthWidget`; параметр `childrenDelegate` заменён на `days: List<DateTime>` и `monthDate: DateTime`.
- `ACCalendarScope` — удалено поле `theme`; тема передаётся только в `ACCalendarTheme` при создании через factory; `updateShouldNotify` сравнивает только `dateRange` и `selectController`.
- Виджеты, читавшие тему через `ACCalendarScope.maybeOf(context)?.theme`, переведены на `ACCalendarTheme.of(context)`: `ACMonthPicker`, `ACWheelPicker`, `ACDayWidget`, `ACPagesCalendarHeader`, `ACWeekWidget`.

## 0.0.9

- `ACPagesCalendarWidget` перестраивается при изменении `range`: диапазон нормализуется, контроллер прокрутки пересоздаётся, текущий месяц зажимается в новые границы.
- Добавлен `dispose` в `_ACPagesCalendarWidgetState`: контроллер прокрутки корректно освобождается при удалении виджета из дерева.

## 0.0.8

- `ACPagesCalendarChildDelegate.buildItem` принимает дополнительный параметр `days: List<DateTime>` — список дней для отображения в сетке месяца, включая дни из соседних месяцев.
- `ACDefaultPagesCalendarChildDelegate` стал stateless: убраны `ACCalendarRepository`, LRU-кэш и параметр `weekStart`; делегат отвечает только за компоновку и геометрию.
- Вычисление дней и LRU-кэш (до 12 месяцев) перенесены в `_ACPagesCalendarWidgetState`.

## 0.0.7

- Добавлен `ACCalendarScope` (InheritedWidget): единая точка доступа к теме, диапазону дат и контроллеру выбора для всего дерева виджетов календаря; оборачивает дочерний виджет в `ACCalendarTheme`, обеспечивая совместимость обоих механизмов получения темы.
- `ACCalendarScope` содержит метод `shouldSelectDay(DateTime day)`: возвращает `true`, если дата входит в `dateRange`; используется `ACDayWidget` самостоятельно без явного параметра.
- `ACCalendarTheme` (InheritedWidget) перенесён в отдельный файл `ac_calendar_theme.dart`; сохранён для автономного использования без `ACCalendarScope`.
- Удалён `ACCalendarSelectionScope` (заменён на `ACCalendarScope`).
- `ACDayWidget` убран параметр `shouldSelect`; доступность дня для выбора определяется автоматически через `ACCalendarScope.shouldSelectDay`.
- `ACDayWidget` читает тему и контроллер из `ACCalendarScope`; явно переданная `theme` имеет приоритет.
- `ACCalendarWidget` принимает опциональный параметр `theme`; оборачивает дерево в `ACCalendarScope`.
- `ACPagesCalendarWidget` оборачивает весь `Column` в `ACCalendarScope`; заголовок, строка дней недели и пикер месяца получают тему из scope.
- `ACVerticalCalendarLayout` и `ACPagesCalendarLayout` упрощены: убраны параметры `range`, `theme`, `onSelectStateForDay`, `onSelectDay`.
- `ACDefaultDaysMonthChildDelegate` упрощён: убраны параметры `onShouldSelect` и `dayTheme`.
- `ACDefaultPagesCalendarChildDelegate` упрощён: убраны параметры `onShouldSelect` и `theme`.

## 0.0.6

- Добавлен `ACDayMonthPosition` enum (`current`, `leading`, `trailing`): описывает принадлежность дня к текущему, предыдущему или следующему месяцу в сетке календаря.
- `ACDayWidget` принимает опциональный параметр `monthPosition: ACDayMonthPosition`; дни с позицией `leading` или `trailing` автоматически неактивны вне зависимости от `shouldSelect`.
- `ACDefaultDaysMonthChildDelegate` принимает обязательный параметр `monthDate: DateTime`; вычисляет `ACDayMonthPosition` для каждого дня; вызывает `onShouldSelect` только для дней с позицией `current`.
- `ACDefaultPagesCalendarChildDelegate.onShouldSelect` упрощён: принимает только `(DateTime day)` — проверка принадлежности дня месяцу перенесена в `ACDefaultDaysMonthChildDelegate` через `ACDayMonthPosition`.
- Исправлена ошибка в `ACPagesCalendarWidget`: при проверке доступности дня теперь используется фактический `widget.range`, а не нормализованный до начала месяца `_range`.

## 0.0.5

- `ACDayWidget` принимает обязательный параметр `shouldSelect` (признак активности дня для выбора).
- `ACDayWidget` принимает опциональные параметры `onSelectStateForDay` и `onSelectDay` для работы без `ACCalendarSelectionScope`.
- `ACDayWidget` самостоятельно читает `ACCalendarSelectionScope` из дерева и оборачивает контент в `ListenableBuilder` при наличии контроллера — логика реактивного обновления перенесена из `ACDefaultMonthChildDelegate`.
- Вычисление цвета фона, цвета текста и стиля текста перенесено из `ACDefaultMonthChildDelegate` в `ACDayWidget`; явно переданные `backgroundColor`, `textColor`, `textStyle` имеют приоритет над вычисляемыми значениями.
- `ACDefaultMonthChildDelegate.buildDay` упрощён: убраны `ListenableBuilder`, `getBackgroundColor`, `getTextColor`, `getTextStyle`, `getResolvedDayTheme`.

## 0.0.4

- Добавлен `ACCalendarSelectionScope` (InheritedWidget): предоставляет `ACCalendarSelectController` вниз по дереву виджетов без перестроения всего календаря.
- `ACCalendarWidget` теперь оборачивает дерево в `ACCalendarSelectionScope`; убран `_selectControllerListener`/`setState` — полное перестроение при выборе даты устранено.
- `ACDefaultMonthChildDelegate.buildDay` оборачивает `ACDayWidget` в `ListenableBuilder`, подписанный на `ACCalendarSelectController` из scope: rebuild происходит только у затронутых дней (2-3 виджета вместо 150-200).
- `ACDefaultMonthChildDelegate.getBackgroundColor` принимает опциональный параметр `selectStateGetter` для переопределения источника состояния выбора.

## 0.0.3

- Добавлены геттеры `shouldBefore` и `shouldAfter` в `ACScrollViewController`: возвращают `true`, если доступен предыдущий или следующий элемент от текущего соответственно.
- Добавлены методы `animateToBeforeItem` и `animateToAfterItem` в `ACScrollViewController`: анимированный переход к предыдущему/следующему элементу; при отсутствии элемента в кэше он добавляется автоматически перед анимацией; поддерживают настраиваемые `duration` и `curve`.
- Добавлен абстрактный делегат `ACPagesCalendarChildDelegate` для `ACPagesCalendarWidget`:
  - Метод `buildItem(BuildContext context, DateTime monthDate)` — построение виджета месяца.
  - Метод `itemHeight(double itemWidth)` — вычисление высоты элемента.
- Добавлена стандартная реализация `ACDefaultPagesCalendarChildDelegate` с поддержкой диапазона дат, темы и обработки выбора дней; реализован LRU-кэш дней по месяцам (до 12 месяцев).
- `ACPagesCalendarWidget` принимает опциональный параметр `childDelegate`; при отсутствии используется `ACDefaultPagesCalendarChildDelegate`.
- Добавлен `ACDateRangeScrollViewController extends DefaultScrollViewController<DateTime>`: инкапсулирует логику ограничения навигации по месяцам на основе `ACDateRange`; используется в `ACPagesCalendarWidget` вместо явных колбэков `onBefore`/`onAfter`.

## 0.0.2

- Оптимизация производительности `ACMonthWidget`:
  - Заменена реализация с `GridView.builder` (shrinkWrap: true) на `CustomMultiChildLayout`.
  - Устранён overhead при вычислении размеров GridView внутри прокручиваемого списка.
  - Добавлен deprecated параметр `useGridView` для обратной совместимости.

- Рефакторинг архитектуры отображения календаря:
  - `ACCalendarWidget` теперь использует `ACMonthWidget` с новой оптимизированной реализацией.
  - Переход с `sliverBuilder` на `itemBuilder` в `ACScrollView`.
  - Удалён `sliverBuilder` из `ACScrollView` - упрощение API и уменьшение сложности кода.
  - Каждый месяц обёрнут в `RepaintBoundary` для изоляции перерисовок.

- Рефакторинг `ACMonthLayout`:
  - `ACMonthLayout` теперь напрямую наследует `MultiChildLayoutDelegate`.
  - Удалён геттер `gridDelegate` - параметры сетки теперь являются полями класса.
  - Удалён промежуточный `_ACMonthLayoutDelegate` - упрощение архитектуры.
  - `DefaultMonthLayout` теперь имеет явные поля для настройки сетки: `crossAxisCount`, `crossAxisSpacing`, `mainAxisSpacing`, `childAspectRatio`.

## 0.0.1

- Начальная версия.
