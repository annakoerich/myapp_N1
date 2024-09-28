import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizador de Anotações',
      theme: ThemeData(
        primaryColor: const Color(0xFF0f928c),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: const Color(0xFF00c9d2),
        ),
        scaffoldBackgroundColor: const Color(0xFF006465),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0f928c),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        cardColor: const Color(0xFF00c9d2),
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> notes = [];
  List<String> selectedCategories = [];
  List<String> categories = ['Matemática', 'História', 'Português'];

  void _addNote(Map<String, String> note) {
    setState(() {
      notes.add(note);
    });
  }

  void _editNote(int index, Map<String, String> updatedNote) {
    setState(() {
      notes[index] = updatedNote;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void _addCategory() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Categoria'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Nome da Categoria'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
                  setState(() {
                    categories.add(newCategory);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoria já existe ou está vazia')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory() {
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Categoria'),
          content: DropdownButton<String>(
            value: selectedCategory,
            hint: const Text('Selecione uma categoria para excluir'),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (selectedCategory != null) {
                  setState(() {
                    categories.remove(selectedCategory);
                    selectedCategories.remove(selectedCategory); // Remover da seleção se necessário
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredNotes = selectedCategories.isEmpty
        ? notes
        : notes.where((note) => selectedCategories.contains(note['categoria'])).toList();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0f928c),
                Color(0xFF00c9d2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              'Anotações de Estudo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: categories.map((category) {
                  return SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: selectedCategories.contains(category),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                            });
                          },
                          side: const BorderSide(color: Colors.white),
                          checkColor: Colors.white,
                          activeColor: Colors.teal,
                        ),
                        Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF13CC19)), // Ícone de adicionar categoria em verde
            onPressed: _addCategory,
            tooltip: 'Adicionar Categoria',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red), // Ícone de lixeira em vermelho
            onPressed: _deleteCategory,
            tooltip: 'Excluir Categoria',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return Card(
            margin: const EdgeInsets.all(16.0),
            color: const Color(0xFF0f928c),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(note['categoria'] ?? 'Categoria', style: const TextStyle(color: Colors.white)),
                    backgroundColor: const Color(0xFF00c9d2),
                  ),
                  const SizedBox(height: 8),
                  Text(note['titulo'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Conteúdo: ${note['conteudo'] ?? ''}', style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Observação: ${note['observacao'] ?? ''}', style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber), // Ícone de editar em amarelo
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditNotePage(
                                categories: categories,
                                note: note,
                                onSave: (updatedNote) {
                                  _editNote(index, updatedNote);
                                  Navigator.pop(context); // Retorna à página anterior
                                },
                              ),
                            ),
                          ).then((_) {
                            // Atualiza a tela de notas quando voltar da página de edição
                            setState(() {});
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), // Ícone de lixeira em vermelho
                        onPressed: () {
                          _deleteNote(index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(
                categories: categories,
                onSave: (note) {
                  _addNote(note);
                  Navigator.pop(context); // Retorna à página anterior
                },
              ),
            ),
          ).then((_) {
            // Atualiza a tela de notas ao voltar da página de adição
            setState(() {});
          });
        },
        backgroundColor: const Color(0xFF00c9d2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddEditNotePage extends StatefulWidget {
  final List<String> categories;
  final Map<String, String>? note;
  final Function(Map<String, String>) onSave;

  const AddEditNotePage({
    super.key,
    required this.categories,
    this.note,
    required this.onSave,
  });

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['titulo'] ?? '';
      _contentController.text = widget.note!['conteudo'] ?? '';
      _observationController.text = widget.note!['observacao'] ?? '';
      _selectedCategory = widget.note!['categoria'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Adicionar Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Conteúdo', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o conteúdo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _observationController,
                decoration: const InputDecoration(labelText: 'Observação', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoria', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave({
                      'titulo': _titleController.text,
                      'conteudo': _contentController.text,
                      'observacao': _observationController.text,
                      'categoria': _selectedCategory ?? '',
                    });
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
