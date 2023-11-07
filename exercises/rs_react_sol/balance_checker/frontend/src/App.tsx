import { useState } from 'react'
import solanaLogo from './assets/solana.png'

const server_url = "http://localhost:3000";

function App() {
    const [error, setError] = useState(null);
    const [balance, setBalance] = useState(0.0);
    const [isExecutable, setIsExecutable] = useState(false);

  return (
    <>
        <main className="bg-sky-100">
            <div className="flex flex-col space-y-4 items-center justify-center min-h-screen">
                <h1 className="text-2xl">Solana Balance Checker</h1>
                <a href="https://solana.com/developers" target="_blank">
                    <img src={solanaLogo} className="logo" alt="Solana logo"/>
                </a>
                <Query setBalance={setBalance} setIsExecutable={setIsExecutable} setError={setError}/>
                {error ? (
                    <p>Error: {error}</p>
                ) : (
                    <>
                        <p>Balance: {balance}</p>
                        <p>Is Executable: {isExecutable.toString()}</p>
                    </>
                )}
            </div>
        </main>
    </>
  )
}

function Query({ setBalance, setIsExecutable, setError}) {
    function query(event) {
        event.preventDefault();
        const address = event.target.address.value;
        const url = `${server_url}/query/${address}`;

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw Error(response.statusText);
                }
                    return response.json();
            })
            .then(data => {
                console.log(data);
                setError(null); // Reset error
                setBalance(data.balance); // Assuming the response has a 'balance' field
                setIsExecutable(data.is_executable); // Assuming the response has an 'is_executable' field
            })
            .catch(error => {
                console.error('Error fetching data:', error.message);
                setError(error.message);
                setBalance(0); // Reset balance
                setIsExecutable(false); // Reset executable state
            });
    }

    return (
        <form onSubmit={query} className="flex flex-col space-y-4">
            <input type="text" name="address" className="border border-gray w-64 text-center" placeholder="Enter address"/>
            <button type="submit">Query</button>
        </form>
    );
}
export default App
