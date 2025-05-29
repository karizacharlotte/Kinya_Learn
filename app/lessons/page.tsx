import { Navigation } from '@/components/Navigation'

const lessons = [
  {
    id: 1,
    title: 'Basic Greetings',
    description: 'Learn common Kinyarwanda greetings and introductions',
    level: 'Beginner',
    duration: '15 min',
  },
  {
    id: 2,
    title: 'Numbers and Counting',
    description: 'Master numbers and basic counting in Kinyarwanda',
    level: 'Beginner',
    duration: '20 min',
  },
  {
    id: 3,
    title: 'Family Members',
    description: 'Learn words for family members and relationships',
    level: 'Beginner',
    duration: '25 min',
  },
]

export default function LessonsPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />
      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <h1 className="text-3xl font-bold text-gray-900 mb-8">Available Lessons</h1>
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {lessons.map((lesson) => (
              <div
                key={lesson.id}
                className="bg-white overflow-hidden shadow-sm rounded-lg hover:shadow-md transition-shadow"
              >
                <div className="p-6">
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">
                    {lesson.title}
                  </h3>
                  <p className="text-gray-600 mb-4">{lesson.description}</p>
                  <div className="flex justify-between items-center">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800">
                      {lesson.level}
                    </span>
                    <span className="text-sm text-gray-500">{lesson.duration}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  )
} 