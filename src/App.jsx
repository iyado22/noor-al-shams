import React, { Suspense } from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { useAuth } from './contexts/AuthContext'
import { useLanguage } from './contexts/LanguageContext'
import LoadingSpinner from './components/ui/LoadingSpinner'
import ErrorBoundary from './components/ui/ErrorBoundary'
import WhatsAppButton from './components/ui/WhatsAppButton'

// Lazy load pages for code splitting
const LandingPage = React.lazy(() => import('./pages/LandingPage'))
const Login = React.lazy(() => import('./pages/auth/Login'))
const Register = React.lazy(() => import('./pages/auth/Register'))
const ClientDashboard = React.lazy(() => import('./pages/client/Dashboard'))
const ClientBooking = React.lazy(() => import('./pages/client/Booking'))
const ClientProfile = React.lazy(() => import('./pages/client/Profile'))
const AdminDashboard = React.lazy(() => import('./pages/admin/Dashboard'))
const AdminUsers = React.lazy(() => import('./pages/admin/Users'))
const AdminServices = React.lazy(() => import('./pages/admin/Services'))
const StaffDashboard = React.lazy(() => import('./pages/staff/Dashboard'))
const StaffSchedule = React.lazy(() => import('./pages/staff/Schedule'))

// Protected Route Component
const ProtectedRoute = ({ children, allowedRoles = [] }) => {
  const { user, isAuthenticated, loading } = useAuth()

  if (loading) {
    return <LoadingSpinner />
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  if (allowedRoles.length > 0 && !allowedRoles.includes(user?.role)) {
    return <Navigate to="/dashboard" replace />
  }

  return children
}

// Page transition variants
const pageVariants = {
  initial: {
    opacity: 0,
    x: -20,
  },
  in: {
    opacity: 1,
    x: 0,
  },
  out: {
    opacity: 0,
    x: 20,
  },
}

const pageTransition = {
  type: 'tween',
  ease: 'anticipate',
  duration: 0.3,
}

function App() {
  const { language } = useLanguage()

  // Update document direction based on language
  React.useEffect(() => {
    document.documentElement.dir = language === 'ar' ? 'rtl' : 'ltr'
    document.documentElement.lang = language
  }, [language])

  return (
    <ErrorBoundary>
      <div className="min-h-screen gradient-bg">
        <AnimatePresence mode="wait">
          <Suspense fallback={<LoadingSpinner />}>
            <Routes>
              {/* Public Routes */}
              <Route 
                path="/" 
                element={
                  <motion.div
                    initial="initial"
                    animate="in"
                    exit="out"
                    variants={pageVariants}
                    transition={pageTransition}
                  >
                    <LandingPage />
                  </motion.div>
                } 
              />
              <Route 
                path="/login" 
                element={
                  <motion.div
                    initial="initial"
                    animate="in"
                    exit="out"
                    variants={pageVariants}
                    transition={pageTransition}
                  >
                    <Login />
                  </motion.div>
                } 
              />
              <Route 
                path="/register" 
                element={
                  <motion.div
                    initial="initial"
                    animate="in"
                    exit="out"
                    variants={pageVariants}
                    transition={pageTransition}
                  >
                    <Register />
                  </motion.div>
                } 
              />

              {/* Client Routes */}
              <Route 
                path="/dashboard" 
                element={
                  <ProtectedRoute allowedRoles={['client']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <ClientDashboard />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />
              <Route 
                path="/booking" 
                element={
                  <ProtectedRoute allowedRoles={['client']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <ClientBooking />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />
              <Route 
                path="/profile" 
                element={
                  <ProtectedRoute allowedRoles={['client']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <ClientProfile />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />

              {/* Admin Routes */}
              <Route 
                path="/admin" 
                element={
                  <ProtectedRoute allowedRoles={['admin']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <AdminDashboard />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />
              <Route 
                path="/admin/users" 
                element={
                  <ProtectedRoute allowedRoles={['admin']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <AdminUsers />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />
              <Route 
                path="/admin/services" 
                element={
                  <ProtectedRoute allowedRoles={['admin']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <AdminServices />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />

              {/* Staff Routes */}
              <Route 
                path="/staff" 
                element={
                  <ProtectedRoute allowedRoles={['staff']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <StaffDashboard />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />
              <Route 
                path="/staff/schedule" 
                element={
                  <ProtectedRoute allowedRoles={['staff']}>
                    <motion.div
                      initial="initial"
                      animate="in"
                      exit="out"
                      variants={pageVariants}
                      transition={pageTransition}
                    >
                      <StaffSchedule />
                    </motion.div>
                  </ProtectedRoute>
                } 
              />

              {/* Catch all route */}
              <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
          </Suspense>
        </AnimatePresence>
        
        {/* WhatsApp Floating Button */}
        <WhatsAppButton />
      </div>
    </ErrorBoundary>
  )
}

export default App