import Navbar from './components/Navbar';
import Hero from './components/Hero';

function App() {
  return (
    <div className="min-h-screen bg-[#FAFAFA] text-[#111111] selection:bg-yellow-300 selection:text-[#111111]">
      <Navbar />
      <main>
        <Hero />

        {/* Cinta continua minimalista */}
        <div className="border-y border-neutral-200 bg-white py-3.5 overflow-hidden select-none">
          <div className="animate-marquee flex items-center gap-10 text-xs font-medium tracking-widest uppercase text-neutral-500">
            <span>Escanea tu prenda con IA</span>
            <span className="text-blue-600">●</span>
            <span>Proyecta el corte en realidad aumentada</span>
            <span className="text-green-600">●</span>
            <span>Conecta con talleres locales</span>
            <span className="text-yellow-500">●</span>
            <span>Moda circular a medida</span>
            <span className="text-red-600">●</span>
            {/* Duplicado para bucle continuo sin saltos */}
            <span>Escanea tu prenda con IA</span>
            <span className="text-blue-600">●</span>
            <span>Proyecta el corte en realidad aumentada</span>
            <span className="text-green-600">●</span>
            <span>Conecta con talleres locales</span>
            <span className="text-yellow-500">●</span>
            <span>Moda circular a medida</span>
            <span className="text-red-600">●</span>
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;