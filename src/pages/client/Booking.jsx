import React, { useState } from 'react'
import { motion } from 'framer-motion'
import { useForm } from 'react-hook-form'
import { Calendar, Clock, User, Star, ArrowLeft, CheckCircle } from 'lucide-react'
import { useQuery, useMutation, useQueryClient } from 'react-query'
import { toast } from 'react-toastify'
import { useNavigate } from 'react-router-dom'
import Header from '../../components/layout/Header'
import Footer from '../../components/layout/Footer'
import LoadingSpinner from '../../components/ui/LoadingSpinner'
import { serviceService } from '../../services/serviceService'
import { staffService } from '../../services/staffService'
import { bookingService } from '../../services/bookingService'

const ClientBooking = () => {
  const [selectedService, setSelectedService] = useState(null)
  const [selectedStaff, setSelectedStaff] = useState(null)
  const [currentStep, setCurrentStep] = useState(1)
  const queryClient = useQueryClient()
  const navigate = useNavigate()

  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
    setValue
  } = useForm()

  // Fetch services
  const { data: servicesData, isLoading: servicesLoading } = useQuery(
    'services',
    () => serviceService.getServices(),
    {
      refetchOnWindowFocus: false,
    }
  )

  // Fetch staff
  const { data: staffData, isLoading: staffLoading } = useQuery(
    'staff',
    () => staffService.getStaffList(),
    {
      refetchOnWindowFocus: false,
    }
  )

  // Create booking mutation
  const createBookingMutation = useMutation(
    (bookingData) => bookingService.createBooking(bookingData),
    {
      onSuccess: () => {
        toast.success('تم حجز الموعد بنجاح!')
        queryClient.invalidateQueries('client-bookings')
        navigate('/dashboard')
      },
      onError: (error) => {
        toast.error(error.message || 'فشل في حجز الموعد')
      }
    }
  )

  const services = servicesData?.data || []
  const staff = staffData?.data || []

  const onSubmit = async (data) => {
    if (!selectedService || !selectedStaff) {
      toast.error('يرجى اختيار الخدمة والموظف')
      return
    }

    const bookingData = {
      service_id: selectedService.id,
      staff_id: selectedStaff.id,
      date: data.date,
      time: data.time,
      notes: data.notes || ''
    }

    createBookingMutation.mutate(bookingData)
  }

  const handleServiceSelect = (service) => {
    setSelectedService(service)
    setValue('service_id', service.id)
    setCurrentStep(2)
  }

  const handleStaffSelect = (staffMember) => {
    setSelectedStaff(staffMember)
    setValue('staff_id', staffMember.id)
    setCurrentStep(3)
  }

  // Generate time slots
  const generateTimeSlots = () => {
    const slots = []
    for (let hour = 10; hour <= 21; hour++) {
      for (let minute = 0; minute < 60; minute += 30) {
        const time = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`
        slots.push(time)
      }
    }
    return slots
  }

  const timeSlots = generateTimeSlots()

  const steps = [
    { number: 1, title: 'اختاري الخدمة', completed: selectedService !== null },
    { number: 2, title: 'اختاري الموظف', completed: selectedStaff !== null },
    { number: 3, title: 'حددي الوقت', completed: false },
  ]

  if (servicesLoading || staffLoading) {
    return (
      <div className="min-h-screen gradient-bg">
        <Header />
        <LoadingSpinner />
        <Footer />
      </div>
    )
  }

  return (
    <div className="min-h-screen gradient-bg">
      <Header />
      
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-8"
        >
          <h1 className="text-3xl font-bold text-gray-900 mb-2">حجز موعد جديد</h1>
          <p className="text-gray-600">اختاري الخدمة والموظف والوقت المناسب لك</p>
        </motion.div>

        {/* Progress Steps */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between">
            {steps.map((step, index) => (
              <div key={step.number} className="flex items-center">
                <div className={`flex items-center justify-center w-10 h-10 rounded-full border-2 ${
                  step.completed || currentStep > step.number
                    ? 'bg-primary-200 border-primary-200 text-white'
                    : currentStep === step.number
                    ? 'border-primary-200 text-primary-200'
                    : 'border-gray-300 text-gray-300'
                }`}>
                  {step.completed || currentStep > step.number ? (
                    <CheckCircle className="w-6 h-6" />
                  ) : (
                    step.number
                  )}
                </div>
                <span className={`mr-3 text-sm font-medium ${
                  step.completed || currentStep >= step.number
                    ? 'text-primary-200'
                    : 'text-gray-500'
                }`}>
                  {step.title}
                </span>
                {index < steps.length - 1 && (
                  <div className={`w-16 h-0.5 mx-4 ${
                    step.completed ? 'bg-primary-200' : 'bg-gray-300'
                  }`} />
                )}
              </div>
            ))}
          </div>
        </motion.div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
          {/* Service Selection */}
          {currentStep >= 1 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              className="card p-6"
            >
              <h2 className="text-xl font-bold text-gray-900 mb-4">اختاري الخدمة</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {services.map((service) => (
                  <div
                    key={service.id}
                    onClick={() => handleServiceSelect(service)}
                    className={`p-4 border-2 rounded-lg cursor-pointer transition-all duration-200 ${
                      selectedService?.id === service.id
                        ? 'border-primary-200 bg-primary-50'
                        : 'border-gray-200 hover:border-primary-100'
                    }`}
                  >
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="font-semibold text-gray-900">{service.name}</h3>
                      <span className="text-primary-200 font-bold">{service.price} ر.س</span>
                    </div>
                    <p className="text-gray-600 text-sm mb-2">{service.description}</p>
                    <div className="flex items-center text-gray-500 text-sm">
                      <Clock className="w-4 h-4 mr-1" />
                      {service.duration} دقيقة
                    </div>
                  </div>
                ))}
              </div>
            </motion.div>
          )}

          {/* Staff Selection */}
          {currentStep >= 2 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="card p-6"
            >
              <h2 className="text-xl font-bold text-gray-900 mb-4">اختاري الموظف</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {staff.map((staffMember) => (
                  <div
                    key={staffMember.id}
                    onClick={() => handleStaffSelect(staffMember)}
                    className={`p-4 border-2 rounded-lg cursor-pointer transition-all duration-200 ${
                      selectedStaff?.id === staffMember.id
                        ? 'border-primary-200 bg-primary-50'
                        : 'border-gray-200 hover:border-primary-100'
                    }`}
                  >
                    <div className="text-center">
                      <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-3">
                        <User className="w-8 h-8 text-primary-200" />
                      </div>
                      <h3 className="font-semibold text-gray-900 mb-1">{staffMember.full_name}</h3>
                      {staffMember.specialization && (
                        <p className="text-gray-600 text-sm mb-2">{staffMember.specialization}</p>
                      )}
                      {staffMember.experience_years && (
                        <p className="text-gray-500 text-sm">{staffMember.experience_years} سنوات خبرة</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </motion.div>
          )}

          {/* Date and Time Selection */}
          {currentStep >= 3 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="card p-6"
            >
              <h2 className="text-xl font-bold text-gray-900 mb-4">اختاري التاريخ والوقت</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Date Selection */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    التاريخ
                  </label>
                  <input
                    {...register('date', {
                      required: 'التاريخ مطلوب',
                      validate: value => {
                        const selectedDate = new Date(value)
                        const today = new Date()
                        today.setHours(0, 0, 0, 0)
                        return selectedDate >= today || 'لا يمكن حجز موعد في الماضي'
                      }
                    })}
                    type="date"
                    min={new Date().toISOString().split('T')[0]}
                    className={`input-field ${errors.date ? 'border-red-500' : ''}`}
                  />
                  {errors.date && (
                    <p className="mt-1 text-sm text-red-600">{errors.date.message}</p>
                  )}
                </div>

                {/* Time Selection */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    الوقت
                  </label>
                  <select
                    {...register('time', {
                      required: 'الوقت مطلوب'
                    })}
                    className={`input-field ${errors.time ? 'border-red-500' : ''}`}
                  >
                    <option value="">اختاري الوقت</option>
                    {timeSlots.map((time) => (
                      <option key={time} value={time}>
                        {time}
                      </option>
                    ))}
                  </select>
                  {errors.time && (
                    <p className="mt-1 text-sm text-red-600">{errors.time.message}</p>
                  )}
                </div>
              </div>
            </motion.div>
          )}

          {/* Notes */}
          {currentStep >= 3 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className="card p-6"
            >
              <h2 className="text-xl font-bold text-gray-900 mb-4">ملاحظات إضافية</h2>
              <textarea
                {...register('notes')}
                rows={4}
                className="input-field resize-none"
                placeholder="أي ملاحظات أو طلبات خاصة..."
              />
            </motion.div>
          )}

          {/* Booking Summary & Submit */}
          {currentStep >= 3 && selectedService && selectedStaff && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
              className="card p-6"
            >
              <h2 className="text-xl font-bold text-gray-900 mb-4">ملخص الحجز</h2>
              <div className="space-y-4 mb-6">
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">الخدمة:</span>
                  <span className="font-semibold">{selectedService.name}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">الموظف:</span>
                  <span className="font-semibold">{selectedStaff.full_name}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">المدة:</span>
                  <span className="font-semibold">{selectedService.duration} دقيقة</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">السعر:</span>
                  <span className="font-bold text-primary-200">{selectedService.price} ر.س</span>
                </div>
              </div>

              <button
                type="submit"
                disabled={createBookingMutation.isLoading}
                className="btn-primary w-full py-3 text-lg font-medium disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {createBookingMutation.isLoading ? (
                  <LoadingSpinner size="sm" text="" />
                ) : (
                  'تأكيد الحجز'
                )}
              </button>
            </motion.div>
          )}
        </form>
      </div>

      <Footer />
    </div>
  )
}

export default ClientBooking