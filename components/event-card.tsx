import Image from "next/image"
import Link from "next/link"
import { Calendar, MapPin } from "lucide-react"

interface EventCardProps {
  title: string
  image: string
  date: string
  location: string
  category: string
  slug?: string
  featured?: boolean
  rating?: number
}

export default function EventCard({
  title,
  image,
  date,
  location,
  category,
  slug = "#",
  featured = false,
  rating,
}: EventCardProps) {
  return (
    <div className="group bg-white rounded-xl overflow-hidden shadow-soft hover:shadow-medium transition-all duration-300 border border-neutral-200 hover:border-primary-300">
      <Link href={`/evento/${slug}`}>
        <div className="relative h-48 overflow-hidden">
          <Image
            src={image || "/placeholder.svg"}
            alt={title}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-500"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        </div>
      </Link>

      <div className="p-5">
        <Link href={`/evento/${slug}`}>
          <h3 className="font-bold text-lg mb-3 group-hover:text-primary-600 transition-colors line-clamp-2 text-neutral-800">
            {title}
          </h3>
        </Link>

        <div className="space-y-2 text-sm text-neutral-600">
          <div className="flex items-center">
            <div className="p-1 rounded-full bg-primary-100 mr-3">
              <Calendar className="h-3 w-3 text-primary-600" />
            </div>
            <span className="font-medium">{date}</span>
          </div>
          <div className="flex items-center">
            <div className="p-1 rounded-full bg-secondary-100 mr-3">
              <MapPin className="h-3 w-3 text-secondary-600" />
            </div>
            <span className="font-medium">{location}</span>
          </div>
        </div>

        <div className="mt-4 pt-4 border-t border-neutral-100">
          <Link
            href={`/evento/${slug}`}
            className="inline-flex items-center text-primary-600 hover:text-primary-700 font-semibold text-sm group/link"
          >
            Ver detalles
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-4 w-4 ml-1 group-hover/link:translate-x-1 transition-transform"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </Link>
        </div>
      </div>
    </div>
  )
}
