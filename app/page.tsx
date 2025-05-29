import Link from 'next/link'
import { Navigation } from '../components/Navigation'

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />
      <main className="flex min-h-[calc(100vh-4rem)] flex-col items-center justify-center p-24">
        <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm">
          <h1 className="text-4xl font-bold text-center mb-8">
            Welcome to KinyaLearn
          </h1>
          <p className="text-center mb-8 text-lg">
            Your journey to mastering Kinyarwanda starts here
          </p>
          <div className="flex justify-center gap-4">
            <Link
              href="/lessons"
              className="px-6 py-3 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors text-lg font-medium"
            >
              Start Learning
            </Link>
            <Link
              href="/about"
              className="px-6 py-3 bg-secondary-600 text-white rounded-lg hover:bg-secondary-700 transition-colors text-lg font-medium"
            >
              About Us
            </Link>
          </div>
        </div>
      </main>
    </div>
  )
} 