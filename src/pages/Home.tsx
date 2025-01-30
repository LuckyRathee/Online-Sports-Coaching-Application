import React from 'react';
import { Link } from 'react-router-dom';
import { Video, Calendar, Users, Trophy } from 'lucide-react';

export default function Home() {
  return (
    <div className="bg-gray-50">
      {/* Hero Section */}
      <div className="relative">
        <div className="absolute inset-0">
          <img
            className="w-full h-full object-cover"
            src="https://images.unsplash.com/photo-1517838277536-f5f99be501cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80"
            alt="Sports coaching"
          />
          <div className="absolute inset-0 bg-gray-900 opacity-75"></div>
        </div>
        
        <div className="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
          <h1 className="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl">
            Transform Your Game with Expert Coaching
          </h1>
          <p className="mt-6 text-xl text-gray-300 max-w-3xl">
            Connect with professional coaches online and take your athletic performance to the next level through personalized video coaching sessions.
          </p>
          <div className="mt-10">
            <Link
              to="/register"
              className="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
            >
              Get Started
            </Link>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="lg:text-center">
            <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Why Choose SportCoach?
            </h2>
          </div>

          <div className="mt-20">
            <div className="grid grid-cols-1 gap-12 lg:grid-cols-3">
              <div className="flex flex-col items-center">
                <Video className="h-12 w-12 text-indigo-600" />
                <h3 className="mt-6 text-xl font-bold text-gray-900">
                  Live Video Sessions
                </h3>
                <p className="mt-2 text-base text-gray-600 text-center">
                  Real-time coaching sessions with HD video quality and instant feedback.
                </p>
              </div>

              <div className="flex flex-col items-center">
                <Calendar className="h-12 w-12 text-indigo-600" />
                <h3 className="mt-6 text-xl font-bold text-gray-900">
                  Flexible Scheduling
                </h3>
                <p className="mt-2 text-base text-gray-600 text-center">
                  Book sessions at your convenience with coaches worldwide.
                </p>
              </div>

              <div className="flex flex-col items-center">
                <Trophy className="h-12 w-12 text-indigo-600" />
                <h3 className="mt-6 text-xl font-bold text-gray-900">
                  Expert Coaches
                </h3>
                <p className="mt-2 text-base text-gray-600 text-center">
                  Learn from certified professionals with proven track records.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}