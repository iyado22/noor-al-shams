import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Banner = () => {
  const [message, setMessage] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchBannerData = async () => {
      try {
        setIsLoading(true);
        const response = await axios.get('/api/Announcements/getActiveAnnouncements.php', {
          timeout: 5000, // 5 second timeout
        });
        
        if (response.data.status === 'success' && Array.isArray(response.data.data)) {
          const latest = response.data.data[0]; // get the first (latest) one
          if (latest?.message) {
            setMessage(latest.message);
          }
        }
      } catch (error) {
        console.error('Failed to load banner announcement:', error);
        // Don't show error to user, just silently fail for banner
      } finally {
        setIsLoading(false);
      }
    };

    fetchBannerData();
  }, []);

  // Don't render anything if loading or no message
  if (isLoading || !message) return null;

  return (
    <div className="sticky top-0 w-full z-50 bg-pink-600 text-white text-center text-lg py-4 px-6 font-bold shadow-md">
      {message}
    </div>
  );
};

export default Banner;