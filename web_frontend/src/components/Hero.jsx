import { useState, useRef } from 'react';
import { MoveHorizontal, ArrowRight, Scissors, Scan } from 'lucide-react';
import jacketBefore from '../assets/jacket-before.jpg';
import jacketAfter from '../assets/jacket-after.jpg';

const THREAD_SWATCHES = [
  { id: 'indigo', name: 'Índigo AR', hex: '#1D4ED8', ring: 'ring-[#1D4ED8]' },
  { id: 'olive', name: 'Verde eco', hex: '#15803D', ring: 'ring-[#15803D]' },
  { id: 'ochre', name: 'Hilo ocre', hex: '#CA8A04', ring: 'ring-[#CA8A04]' },
  { id: 'crimson', name: 'Pespunte rojo', hex: '#DC2626', ring: 'ring-[#DC2626]' },
];

export default function Hero() {
  const [sliderPos, setSliderPos] = useState(50);
  const [activeThread, setActiveThread] = useState(THREAD_SWATCHES[0]);
  const containerRef = useRef(null);

  const updatePosition = (clientX) => {
    if (!containerRef.current) return;
    const rect = containerRef.current.getBoundingClientRect();
    const x = Math.max(0, Math.min(clientX - rect.left, rect.width));
    setSliderPos((x / rect.width) * 100);
  };

  const handleMouseMove = (e) => {
    if (e.buttons !== 1) return;
    updatePosition(e.clientX);
  };

  const handleTouchMove = (e) => {
    if (e.touches.length > 0) {
      updatePosition(e.touches[0].clientX);
    }
  };

  return (
    <section className="max-w-7xl mx-auto px-6 sm:px-8 pt-12 pb-16 lg:pt-24 lg:pb-24">
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
        
        {/* Columna izquierda: texto y muestrario de hilos */}
        <div className="lg:col-span-6 space-y-6">
          
          <div className="inline-flex items-center gap-2 text-[13px] text-[#5E554A]">
            <Scan className="w-4 h-4 stroke-[1.5] text-[#7B7266]" />
            <span>Escaneo en realidad aumentada y confección en taller</span>
          </div>

          <h1 className="text-[36px] sm:text-[44px] lg:text-[60px] font-normal tracking-[-0.025em] leading-[1.05] text-[#1F1B16]">
            Rediseña las prendas que{' '}
            <span className="font-serif text-[#5E554A]">ya viven</span>{' '}
            en tu armario
          </h1>

          <p className="text-[18px] leading-[28px] font-normal text-[#5E554A] max-w-[36rem]">
            Escanea ropa en desuso desde tu teléfono, proyecta cortes y costuras a medida en realidad aumentada y envíala a un taller local para darle una segunda vida.
          </p>

          {/* Muestrario de hilo (único punto multicolor de la página) */}
          <div className="pt-2 space-y-3">
            <div className="flex items-center justify-between max-w-xs text-[13px]">
              <span className="text-[#7B7266]">Color de puntada AR</span>
              <span className="font-medium text-[#1F1B16]">{activeThread.name}</span>
            </div>

            <div className="flex items-center gap-3">
              {THREAD_SWATCHES.map((swatch) => {
                const isSelected = activeThread.id === swatch.id;
                return (
                  <button
                    key={swatch.id}
                    type="button"
                    onClick={() => setActiveThread(swatch)}
                    aria-label={swatch.name}
                    style={{ backgroundColor: swatch.hex }}
                    className={`w-7 h-7 rounded-full transition-atelier cursor-pointer focus:outline-none focus-visible:ring-2 ${
                      isSelected
                        ? `ring-2 ring-offset-2 ring-offset-[#F7F4EE] ${swatch.ring}`
                        : 'opacity-80 hover:opacity-100'
                    }`}
                  />
                );
              })}
            </div>
          </div>

          {/* Acciones */}
          <div className="pt-2 flex flex-wrap items-center gap-3">
            <a
              href="#descargar"
              className="h-11 px-5 rounded-lg bg-[#1F1B16] hover:bg-[#332D25] text-[#FDFBF7] text-[14px] font-medium transition-atelier inline-flex items-center gap-2"
            >
              <span>Escanear primera prenda</span>
              <ArrowRight className="w-4 h-4 stroke-[1.5] text-[#EFE9DF]" />
            </a>

            <a
              href="#lookbook"
              className="h-11 px-5 rounded-lg bg-[#EFE9DF] hover:bg-[#E5DDD0] text-[#1F1B16] border border-[#1F1B16]/8 text-[14px] font-medium transition-atelier inline-flex items-center gap-2"
            >
              <span>Ver catálogo</span>
            </a>
          </div>

          {/* Métricas estimadas de la pieza */}
          <div className="pt-6 border-t border-[#1F1B16]/8 grid grid-cols-3 gap-6 max-w-lg tabular-nums">
            <div>
              <p className="text-[12px] leading-[16px] text-[#7B7266]">Ahorro estimado</p>
              <p className="text-[16px] font-medium text-[#1F1B16] mt-1">2,100 L agua</p>
            </div>
            <div>
              <p className="text-[12px] leading-[16px] text-[#7B7266]">Trazo de patrón</p>
              <p className="text-[16px] font-medium text-[#1F1B16] mt-1">30 seg</p>
            </div>
            <div>
              <p className="text-[12px] leading-[16px] text-[#7B7266]">Red disponible</p>
              <p className="text-[16px] font-medium text-[#1F1B16] mt-1">42 talleres</p>
            </div>
          </div>
        </div>

        {/* Columna derecha: comparador Antes / Después */}
        <div className="lg:col-span-6">
          <div
            ref={containerRef}
            onMouseDown={(e) => updatePosition(e.clientX)}
            onMouseMove={handleMouseMove}
            onTouchStart={handleTouchMove}
            onTouchMove={handleTouchMove}
            className="relative w-full aspect-[4/5] max-w-lg mx-auto rounded-2xl overflow-hidden bg-[#F7F4EE] border border-[#1F1B16]/8 select-none touch-none cursor-ew-resize"
          >
            {/* Capa base (derecha): prenda rediseñada con trazo de corte */}
            <div className="absolute inset-0">
              <img
                src={jacketAfter}
                alt="Chaqueta de mezclilla transformada con paneles de lino y algodón"
                className="w-full h-full object-cover"
                draggable="false"
              />

              {/* Trazo de costura AR sobre los paneles de la chaqueta */}
              <svg
                viewBox="0 0 400 500"
                className="absolute inset-0 w-full h-full pointer-events-none"
              >
                {/* Panel bolsillo izquierdo */}
                <rect
                  x="130"
                  y="148"
                  width="54"
                  height="64"
                  rx="2"
                  fill="none"
                  stroke={activeThread.hex}
                  strokeWidth="1.5"
                  strokeDasharray="6 4"
                />
                {/* Panel inferior torso */}
                <path
                  d="M 122 252 L 278 252 L 274 378 L 126 378 Z"
                  fill="none"
                  stroke={activeThread.hex}
                  strokeWidth="1.5"
                  strokeDasharray="6 4"
                />
                {/* Alfileres de registro en esquinas */}
                <circle cx="130" cy="148" r="3" fill={activeThread.hex} />
                <circle cx="184" cy="148" r="3" fill={activeThread.hex} />
                <circle cx="122" cy="252" r="3" fill={activeThread.hex} />
                <circle cx="278" cy="252" r="3" fill={activeThread.hex} />
              </svg>

              <div className="absolute top-4 right-4 bg-[#FDFBF7]/92 backdrop-blur-sm text-[#1F1B16] border border-[#1F1B16]/8 text-[12px] font-medium px-3 py-1.5 rounded-md inline-flex items-center gap-2">
                <Scissors className="w-4 h-4 stroke-[1.5] text-[#5E554A]" />
                <span>Patrón propuesto</span>
              </div>
            </div>

            {/* Capa recortada (izquierda): prenda original */}
            <div
              style={{ clipPath: `inset(0 ${100 - sliderPos}% 0 0)` }}
              className="absolute inset-0"
            >
              <img
                src={jacketBefore}
                alt="Chaqueta de mezclilla original antes del rediseño"
                className="w-full h-full object-cover"
                draggable="false"
              />
              <div className="absolute top-4 left-4 bg-[#1F1B16]/88 backdrop-blur-sm text-[#FDFBF7] text-[12px] font-medium px-3 py-1.5 rounded-md">
                Prenda original
              </div>
            </div>

            {/* Línea divisoria y tirador */}
            <div
              style={{ left: `${sliderPos}%` }}
              className="absolute top-0 bottom-0 w-px bg-[#1F1B16]/35 pointer-events-none"
            >
              <div className="absolute top-1/2 -translate-x-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-[#FDFBF7] text-[#1F1B16] shadow-[0_8px_24px_rgba(31,27,22,0.12)] flex items-center justify-center border border-[#1F1B16]/12">
                <MoveHorizontal className="w-4 h-4 stroke-[1.5]" />
              </div>
            </div>
          </div>

          <p className="text-center text-[12px] leading-[16px] text-[#7B7266] mt-3">
            Arrastra sobre la prenda para comparar el estado inicial y el trazo de corte
          </p>
        </div>

      </div>
    </section>
  );
}