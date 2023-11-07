import { useState, useEffect } from 'react';

// Needs work

const url_check: string = process.env.NODE_ENV === 'development' ? 'http://localhost:4001/api/check' : 'https://treefi.xyz/api/check';
const url_redirect: string = process.env.NODE_ENV === 'development' ? 'http://localhost:4000/app' : 'https://treefi.xyz/app';

const useNetworkStatus= (endpoint: string) => {
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    const intervalId = setInterval(() => {
      fetch(endpoint)
      .then(response => {
        if (response.ok) {
          setIsConnected(true);
        } else {
          setIsConnected(false);
        }
      })
      .catch(() => setIsConnected(false));
    }, 1_500);

    return () => clearInterval(intervalId);
  }, [isConnected, endpoint]);

  return isConnected;
};

function App() {
  const isNetworkConnected = useNetworkStatus(url_check);

  useEffect(() => {
    if (isNetworkConnected) {
      window.location.href = url_redirect;
    }
  }, [isNetworkConnected]);

  return (
    // PWA requirements
    // <head>
    //   <meta name="viewport" content="width=device-width,initial-scale=1">
    //   <title>My Awesome App</title>
    //   <meta name="description" content="My Awesome App description">
    //   <link rel="icon" href="/favicon.ico">
    //   <link rel="apple-touch-icon" href="/apple-touch-icon.png" sizes="180x180">
    //   <link rel="mask-icon" href="/mask-icon.svg" color="#FFFFFF">
    //   <meta name="theme-color" content="#ffffff">
    // </head>
    <section>
      <h1 className="text-3xl font-bold underline">
        TreeFi
      </h1>
      <p>{isNetworkConnected ? "Redirecting..." : "No connection..."}</p>
      <div>
        {isNetworkConnected ? (
          <p>You are online!</p>
        ) : (
          <p>You are offline. Please check your network connection.</p>
        )}
      </div>
    </section>
  );
}

export default App;
