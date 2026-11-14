import Navbar from './components/Navbar';
import Hero from './components/Hero';

export default function App() {
  return (
    <div className="min-h-screen bg-[#F7F4EE] text-[#1F1B16] selection:bg-[#EFE9DF] selection:text-[#1F1B16]">
      <Navbar />
      <main>
        <Hero />

        {/* Franja estática del flujo de trabajo */}
        <section
          id="proceso"
          className="border-y border-[#1F1B16]/8 bg-[#FDFBF7]"
        >
          <div className="max-w-7xl mx-auto px-6 sm:px-8 py-6 grid grid-cols-1 md:grid-cols-3 gap-6 text-[14px] leading-[20px] tabular-nums">
            <div className="flex items-baseline gap-3">
              <span className="text-[12px] text-[#7B7266]">01</span>
              <span className="text-[#5E554A]">
                Escaneo de medidas y desgaste con cámara móvil
              </span>
            </div>
            <div className="flex items-baseline gap-3">
              <span className="text-[12px] text-[#7B7266]">02</span>
              <span className="text-[#5E554A]">
                Proyección de cortes y parches en realidad aumentada
              </span>
            </div>
            <div className="flex items-baseline gap-3">
              <span className="text-[12px] text-[#7B7266]">03</span>
              <span className="text-[#5E554A]">
                Envío directo de ficha técnica a talleres locales
              </span>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}