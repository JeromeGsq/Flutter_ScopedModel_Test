Flutter ScopedModel
===============

**ScopedModel package**: https://pub.dev/packages/scoped_model

_______________
> In my opinion, this is the best design pattern for small applications.
Be warned, ScopedModel rebuilds each ScopedModelDescendant widgets when you call `notifyListeners()`. This is not optimized.
_______________

• **files and folders**
```
Project
+-- lib
    +-- pages
        +-- Example
            |-- example.dart
            |-- example_model.dart
            +-- example_page.dart
```
• **example.dart**

Useful to `import` each file in this folder:
```dart
export 'example_model.dart';
export 'example_page.dart';
```

• **example_model.dart**
```dart
class ExampleModel extends Model {
  // Variables
  bool isBusy;
  int pageIndex;
  String title;
  Data data;

  // Constructor
  ExampleModel({
    this.isBusy = false,
    this.pageIndex = 0,
    this.title = "",
    this.data,
  });

  Future initialize() async {
    // Init variables here
    this.pageIndex = 1;
    this.title = "Title from `initialize` method";
    this.data = Data();

    // You can call `loadData()` if you want
    await this.loadData();
  }

  Future loadData() async {
    this.isBusy = true;
    this.title = "Loading";

    // Call `notifyListeners()` when you want to notify the UI to refresh values
    this.notifyListeners();

    var data = await ApiClient().getData(this.pageIndex);
    if (data != null) {
      this.pageIndex++;
      this.data = data;

      this.title = "Next page to load : ${this.pageIndex}";
    } else {
      this.title = "Error could not load data";
    }

    this.isBusy = false;
    // You can call `notifyListeners()` multiple times inside one function.
    // Warning : each ScopedModelDescendant will be rebuilt !
    this.notifyListeners();
  }
}
```

• **example_page.dart**
Create your state here. 
Don't forget to call `initialize()`.

```dart
// Statefulwidget
class _ExamplePageState extends State<ExamplePage> {
  ExampleModel _model = ExampleModel();

  @override
  void initState() {
    // Usefull to initialize values from the model
    this._model.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the model to each ScopedModelDescendant
    return ScopedModel<ExampleModel>(
      model: this._model,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Center(
            // Access to ExampleModel, provided by ScopedModel<ExampleModel>
            // Warning : each ScopedModelDescendant will be rebuilt 
            // when you will call 'notifyListeners()' even if you don't change anything. 
            // So, don't encapsulate everything in this widget.
            child: ScopedModelDescendant<ExampleModel>(
              builder: (context, child, model) {
                return Text(model.title);
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

• **Call model functions** 
```dart
FloatingActionButton(
   child: Icon(Icons.clear),
   onPressed: () {
    // You have access to your model in your widget tree 
    // because you create it inside `_ExamplePageState`
    this._model.loadData();
   },
),
```

• **Navigation**
You can use the `Navigator`:
```dart
MaterialButton(
   height: 100,
   color: Colors.blueGrey[50],
   onPressed: () {
      Navigator.of(context).pushNamed(
         "/next_page",
         arguments: "ExampleArgument",
      );
   },
)
```

Here are some rules:
===============

1. Every `model` need to extends `Model`.
2. Each time you call `notifyListeners()`, every ScopedModelDescendant will be rebuilt. :(
3. Don't encapsulate everything in one `ScopedModelDescendant` widget, only what is likely to change.
4. ScopedModel is very useful to create and maintain small applications only.


Pro/Cons
===============
**Cons:** 

• Each time you call `notifyListeners()`, every ScopedModelDescendant will be rebuilt, again.

• Not the best design pattern for big applications, according to the web.

• It is easy to make mistakes and add the whole page inside a ScopedModelDescendant widget (don't do that).

• Need a lot of ScopedModelDescendant in the UI code to separate what is dynamic and static.

• What about Unit testing with ScopedModel ? [example here](https://github.com/brianegan/scoped_model/blob/master/test/scoped_model_test.dart)

**Pros:**

• Very easy to learn and to implement.

• Call `notifyListeners()` and everything is up-to-date.

• Only 2 files to create a new page.

• Only two widgets : ScopedModel and ScopedModelDescendant

• If you like MVVM, you may like ScopedModel like me.

• You don't waste time maintaining a design pattern, so you can focus on UI, error handling, etc.


