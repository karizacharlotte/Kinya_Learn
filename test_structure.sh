#!/bin/bash

echo "Testing the Kinyarwanda Learning App Structure..."
echo "1. Checking language lessons file..."
if [ -f "/home/kariza/Downloads/Kinya_Learn/lib/data/language_lessons.dart" ]; then
    echo "✓ Language lessons file exists"
    echo "Number of lessons: $(grep -c 'order:' /home/kariza/Downloads/Kinya_Learn/lib/data/language_lessons.dart)"
else
    echo "✗ Language lessons file missing"
fi

echo "2. Checking culture lessons file..."
if [ -f "/home/kariza/Downloads/Kinya_Learn/lib/data/culture_lessons.dart" ]; then
    echo "✓ Culture lessons file exists"
    echo "Number of lessons: $(grep -c 'order:' /home/kariza/Downloads/Kinya_Learn/lib/data/culture_lessons.dart)"
else
    echo "✗ Culture lessons file missing"
fi

echo "3. Checking lessons screen update..."
if grep -q "KinyarwandaLanguageLessons" /home/kariza/Downloads/Kinya_Learn/lib/pages/lessons_screen.dart; then
    echo "✓ Lessons screen updated to use language lessons"
else
    echo "✗ Lessons screen not properly updated"
fi

echo "4. Checking culture screen update..."
if grep -q "CultureLessons" /home/kariza/Downloads/Kinya_Learn/lib/pages/culture_screen.dart; then
    echo "✓ Culture screen updated to use culture lessons"
else
    echo "✗ Culture screen not properly updated"
fi

echo "5. Checking practice screen update..."
if grep -q "languageLessons\|cultureLessons" /home/kariza/Downloads/Kinya_Learn/lib/pages/practice_selection_screen.dart; then
    echo "✓ Practice screen updated to use both lesson types"
else
    echo "✗ Practice screen not properly updated"
fi

echo "Testing complete!"
