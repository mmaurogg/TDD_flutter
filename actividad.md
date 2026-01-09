# Taller de **Flutter**: “Habit Tracker” con **TDD en Funciones y en UI**

## Introducción

En este taller vas a construir una app sencilla de hábitos (“Habit Tracker”) y, a la vez, aprenderás a trabajar con **TDD (Test-Driven Development)** tanto en **lógica pura (funciones)** como en **UI (widgets)**. La app crecerá paso a paso: cada nueva capacidad se añade **sin romper lo anterior**, y lo verificas con pruebas automatizadas.

## Objetivo general (SMART)

Al finalizar, en una sola sesión de práctica guiada, implementarás una app Flutter de hábitos que permite **listar, marcar como completado, filtrar y persistir hábitos**, usando **TDD** para:

* funciones (tests unitarios)
* UI (widget tests)
  y manteniendo una base de pruebas verde (passing) en cada checkpoint.

## Objetivos específicos

* Escribir **tests unitarios** para funciones puras (sin Flutter UI).
* Aplicar el ciclo **Red → Green → Refactor** con ejemplos reales.
* Crear **widget tests** para UI: renderizado, interacción (tap) y estado visible.
* Separar responsabilidades: **dominio (lógica)** vs **presentación (widgets)**.
* Incorporar persistencia simple y testearla con dobles (fake/in-memory).

## Arquitectura y Flujo de la App

Capas simples (para principiantes):

* **Dominio**: modelos + funciones puras (reglas)
* **Datos**: repositorio (in-memory al inicio)
* **UI**: widgets (pantallas y componentes)

Flujo principal (ASCII):

```
[HabitListScreen]
   | tap "Completar"
   v
[UI llama a controlador sencillo]
   v
[Dominio: reglas (funciones)]
   v
[Repo: guarda/carga]
   v
[UI se actualiza]
```

## Roadmap de Pasos

1. Preparar proyecto + primera prueba “sanity”
2. Modelar Habit + **TDD de funciones** (toggle/contadores)
3. Construir lista UI mínima + **widget test de renderizado**
4. Interacción: completar hábito + **widget test con tap**
5. Filtros (Todos/Activos/Completados) + **TDD de reglas** + **test UI**
6. Persistencia (in-memory → shared prefs o archivo simple) + tests con fake
7. Refactor guiado: limpieza, nombres, cobertura y checklist de demo

---

## Pasos detallados

### Paso 1: **Inicializar el proyecto y asegurar el pipeline de tests**

* **Objetivo del paso:** crear el proyecto, correr tests y dejar un test mínimo pasando.
* **Conexión con la app:** base para que todo lo demás se valide automáticamente.
* **Progresión del tema (básico → intermedio):**

  * Básico: ejecutar `flutter test`.
  * Intermedio: organizar carpetas (`lib/domain`, `lib/data`, `lib/ui`, `test/`).
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: estructura libre | Opción B: estructura por capas (recomendada: **capas** por claridad en TDD)
* **Guía de implementación (sin solución completa):**

  * Crea estructura de carpetas.
  * Añade un test trivial para validar que el runner funciona.
  * Fragmento mínimo (ejemplo):

    ```dart
    test('sanity', () {
      expect(1 + 1, 2);
    });
    ```
* **Consultas sugeridas (docs oficiales/keywords):**

  * Búscalo como: “flutter test widget testing overview” en la doc de Flutter
  * Búscalo como: “package:test basics Dart” en la doc de Dart
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué ganas si cada cambio corre tests en segundos?”
* **Checkpoint (lo que debes ver ahora):**

  * `flutter test` termina en verde con al menos 1 test.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): crea una carpeta `test/domain` **Criterio:** existe y el test corre.
  * Reto 2 (medio): agrega un `Makefile` o script simple para correr tests **Criterio:** un comando único ejecuta tests.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: “No tests were found” | Pista: “revisa el sufijo `_test.dart`”
* **Extensión opcional:** configura un formateador (`dart format`) y aplícalo al proyecto.

---

### Paso 2: **Modelar un hábito y validar reglas con TDD (funciones)**

* **Objetivo del paso:** crear `Habit` y funciones puras para “marcar completado”.
* **Conexión con la app:** esta lógica será usada por la UI después.
* **Progresión del tema (básico → intermedio):**

  * Básico: `toggleCompleted(Habit)` o `Habit.toggle()`.
  * Intermedio: reglas: si completas hoy, incrementa “streak”; si desmarcas, revierte.
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: mutar el objeto | Opción B: inmutable y devolver copia (recomendada: **inmutable** para tests más simples)
* **Guía de implementación (sin solución completa):**

  * Crea `lib/domain/habit.dart`.
  * Escribe primero tests: “al togglear, cambia completed”.
  * Pseudocódigo:

    * Given Habit(completed=false)
    * When toggle
    * Then completed=true
* **Consultas sugeridas (docs oficiales/keywords):**

  * “Dart data classes equals hashCode” (para comparar objetos en tests)
  * “Dart copyWith pattern” (si usas inmutabilidad)
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué partes de tu lógica pueden ser 100% testeables sin Flutter?”
* **Checkpoint (lo que debes ver ahora):**

  * Tests unitarios validan toggle y reglas básicas (verde).
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): agrega propiedad `title` **Criterio:** tests siguen verdes.
  * Reto 2 (medio): agrega `completedAt` (nullable) **Criterio:** al completar se setea; al descompletar vuelve a null.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: igualdad falla en `expect(h1, h2)` | Pista: “implementa `==`/`hashCode` o compara campos”
* **Extensión opcional:** agrega función pura `isDueToday(habit, now)` con tests de fechas.

---

### Paso 3: **Crear la UI mínima y testear renderizado (widget test)**

* **Objetivo del paso:** mostrar una lista de hábitos en pantalla.
* **Conexión con la app:** consumir el dominio desde UI (sin interacción aún).
* **Progresión del tema (básico → intermedio):**

  * Básico: `HabitListScreen` con `ListView`.
  * Intermedio: extraer `HabitTile` para testear componentes pequeños.
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: todo en un widget | Opción B: componentes pequeños (recomendada: **HabitTile** reusable)
* **Guía de implementación (sin solución completa):**

  * Crea `lib/ui/habit_list_screen.dart`.
  * Escribe test: “se renderiza título X”.
  * Fragmento mínimo (test):

    ```dart
    await tester.pumpWidget(MaterialApp(home: HabitListScreen(habits: habits)));
    expect(find.text('Tomar agua'), findsOneWidget);
    ```
* **Consultas sugeridas (docs oficiales/keywords):**

  * “Flutter widget tests pumpWidget find text”
  * “MaterialApp required for tests”
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué tan estable es un test que busca texto vs uno que busca keys?”
* **Checkpoint (lo que debes ver ahora):**

  * Widget test pasa y UI muestra lista con 2-3 hábitos.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): muestra un ícono distinto si está completado **Criterio:** test verifica el ícono.
  * Reto 2 (medio): usa `Key` en cada tile **Criterio:** test encuentra por `Key('habit_<id>')`.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: “No Material widget found” | Pista: “envuelve con `MaterialApp`/`Scaffold`”
* **Extensión opcional:** agrega estado vacío (“No hay hábitos”) con test.

---

### Paso 4: **Implementar interacción (tap) y testear cambios visibles**

* **Objetivo del paso:** al tocar un hábito, se marca como completado y cambia la UI.
* **Conexión con la app:** la UI usa la función del dominio (Paso 2).
* **Progresión del tema (básico → intermedio):**

  * Básico: `onTap` llama a `toggle`.
  * Intermedio: separar lógica de UI con un controlador simple (`HabitController`) testeable.
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: `setState` directo | Opción B: controlador + estado (recomendada: **controlador simple** para testear mejor)
* **Guía de implementación (sin solución completa):**

  * Widget test:

    * Renderiza
    * Tap en tile
    * Pump
    * Verifica ícono/estilo de completado
  * Pseudocódigo test:

    * tap(find.byKey(Key('habit_1')))
    * pump()
    * expect(find.byIcon(Icons.check), findsOneWidget)
* **Consultas sugeridas (docs oficiales/keywords):**

  * “WidgetTester tap pump”
  * “setState and widget testing”
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué te conviene testear: el estado interno o el resultado visible?”
* **Checkpoint (lo que debes ver ahora):**

  * Un tap cambia el estado y el test lo confirma.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): cambia el estilo del texto (tachado) al completar **Criterio:** test verifica `TextStyle`.
  * Reto 2 (medio): agrega botón “Deshacer” con `SnackBar` **Criterio:** test verifica que aparece el snack.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: el test tapa pero no cambia nada | Pista: “¿hiciste `pump()` después del tap?”
* **Extensión opcional:** agrega contador “Completados: N” con test.

---

### Paso 5: **Agregar filtros y validarlos con TDD en reglas + UI**

* **Objetivo del paso:** filtrar hábitos: Todos / Activos / Completados.
* **Conexión con la app:** amplía lógica (función pura) y la UI la consume.
* **Progresión del tema (básico → intermedio):**

  * Básico: función pura `filterHabits(habits, filter)`.
  * Intermedio: testear que la UI muestra cantidad correcta al cambiar filtro.
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: filtrar en UI | Opción B: filtrar en dominio (recomendada: **dominio**, más testeable)
* **Guía de implementación (sin solución completa):**

  * Tests de dominio:

    * Given lista mixta
    * When filter=completed
    * Then devuelve solo completados
  * UI:

    * `SegmentedButton`/`DropdownButton` simple
    * Widget test cambia filtro y verifica `findsNWidgets`
* **Consultas sugeridas (docs oficiales/keywords):**

  * “Flutter DropdownButton widget test select”
  * “SegmentedButton Flutter”
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué cambia en tus tests si mañana agregas ‘Vencidos’?”
* **Checkpoint (lo que debes ver ahora):**

  * Filtros funcionan y tests cubren reglas + UI.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): filtro persiste durante la sesión **Criterio:** no se pierde al completar hábitos.
  * Reto 2 (medio): muestra “Activos (N)” y “Completados (M)” **Criterio:** test valida conteos.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: test no logra seleccionar opción | Pista: “usa `Key` en el control del filtro”
* **Extensión opcional:** agrega búsqueda por texto con función pura + test.

---

### Paso 6: **Persistencia con repositorio y tests con dobles (fake)**

* **Objetivo del paso:** guardar y cargar hábitos.
* **Conexión con la app:** los hábitos sobreviven reinicios (o al menos simulas persistencia).
* **Progresión del tema (básico → intermedio):**

  * Básico: `HabitRepository` in-memory (lista en memoria) con tests.
  * Intermedio: swap a persistencia real (p. ej. `shared_preferences`) manteniendo los mismos tests de contrato (más alguno de integración).
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: UI llama directo a shared prefs | Opción B: `Repository` abstrae datos (recomendada: **Repository** para testear fácil)
* **Guía de implementación (sin solución completa):**

  * Define interfaz:

    * `Future<List<Habit>> load()`
    * `Future<void> save(List<Habit>)`
  * Tests:

    * Given repo
    * When save + load
    * Then devuelve lo guardado
* **Consultas sugeridas (docs oficiales/keywords):**

  * “shared_preferences Flutter plugin”
  * “dependency injection simple Flutter pass repository”
* **Preguntas catalizadoras (reflexión):**

  * “¿Cómo harías para testear sin tocar disco/red?”
* **Checkpoint (lo que debes ver ahora):**

  * Al reiniciar (o simular recarga), los hábitos se restauran; tests del repo en verde.
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): agrega migración simple (si no hay data, carga defaults) **Criterio:** test para estado vacío.
  * Reto 2 (medio): maneja error de carga (devuelve defaults) **Criterio:** test con fake que lanza excepción.
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: flakiness por async | Pista: “asegura `await` y `pumpAndSettle` cuando aplique”
* **Extensión opcional:** agrega timestamp de última actualización con test.

---

### Paso 7: **Refactor seguro y calidad mínima de suite**

* **Objetivo del paso:** limpiar código sin romper funcionalidad, mejorando legibilidad y cobertura.
* **Conexión con la app:** dejas una base mantenible para seguir creciendo.
* **Progresión del tema (básico → intermedio):**

  * Básico: renombrar, extraer métodos, reducir duplicación (con tests como red).
  * Intermedio: introducir “tests de contrato” del repositorio (mismo set para fake/real).
* **Decisiones de diseño a tomar (elige y justifica):**

  * Opción A: refactor grande de una | Opción B: refactor pequeño y frecuente (recomendada: **pequeño y frecuente**)
* **Guía de implementación (sin solución completa):**

  * Identifica 2-3 smells:

    * widgets demasiado grandes
    * lógica en UI
    * nombres ambiguos
  * Refactor: “extraer widget”, “extraer función”, “extraer repositorio”
* **Consultas sugeridas (docs oficiales/keywords):**

  * “refactoring with tests”
  * “Flutter keys best practices”
* **Preguntas catalizadoras (reflexión):**

  * “¿Qué parte del código te da más miedo tocar? ¿Qué test faltaría?”
* **Checkpoint (lo que debes ver ahora):**

  * Suite verde + código más simple (menos líneas en widgets grandes).
* **Retos (según nivel) con criterios de aceptación:**

  * Reto 1 (fácil): agrega `Key` a controles críticos **Criterio:** tests dejan de depender de texto.
  * Reto 2 (medio): reduce un widget grande en 2-3 componentes **Criterio:** tests siguen pasando sin cambios (o mínimos).
* **Errores comunes (síntomas) & pistas:**

  * Síntoma: tests se rompen por refactor visual | Pista: “testea intención (estado visible) y usa keys”
* **Extensión opcional:** agrega un test que valide el flujo completo “completar + filtrar completados”.

---

## Integración final & Demo

**Pasos de ensamblaje**

1. Corre `flutter test` (debe estar verde).
2. Ejecuta la app.
3. Crea/visualiza hábitos (o carga defaults).
4. Completa 1 hábito.
5. Cambia filtro a “Completados”.
6. Reinicia (o fuerza recarga) y confirma persistencia.

**Checklist final**

* [ ] Tests unitarios cubren reglas principales (toggle, filtros).
* [ ] Widget tests cubren render + interacción (tap + filtro).
* [ ] Repo abstrae persistencia (fake testeable).
* [ ] UI responde a cambios con estado visible.

**Guion corto de demo (2–3 min)**

* “Primero muestro la suite verde → luego tap para completar → filtro completados → reinicio y se mantiene → enseño 1 test unitario y 1 widget test que validan esto.”

---

## Rúbrica de evaluación (0–5)

* **Funcionalidad (0–5):**

  * 5: lista, completar, filtrar, persistir; sin bugs visibles; edge cases básicos.
* **Calidad técnica (0–5):**

  * 5: dominio separado, repo claro, nombres coherentes, poco acoplamiento UI-lógica.
* **UX (0–5):**

  * 5: estados vacíos, feedback (ícono/estilo), controles claros.
* **Pruebas (0–5):**

  * 5: suite estable, tests legibles, cubren reglas y UI crítica (sin flakiness).

---

## Material de apoyo

**Enlaces oficiales (sugeridos para investigar)**

* Documentación oficial de Flutter: testing (unit y widget tests)
* Documentación de Dart: package:test
* shared_preferences (pub.dev) para persistencia simple
* Flutter: Keys, Finder y WidgetTester (conceptos de testing)

**Glosario breve**

* **TDD:** escribir prueba → hacerla pasar → refactor.
* **Unit test:** prueba de lógica (sin UI).
* **Widget test:** prueba de UI en entorno de test (sin dispositivo real).
* **Fake:** implementación simple para testear sin dependencias externas.
* **Finder:** herramienta para “encontrar” widgets en tests (por texto, key, tipo).