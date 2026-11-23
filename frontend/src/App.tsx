import {
  BookOpen,
  GraduationCap,
  Heart,
  House,
  LibraryBig,
  Search,
  Sparkles,
  UsersRound,
} from "lucide-react";
import EditorialPages from "./EditorialPages";
import FeaturedVideoCard from "./FeaturedVideoCard";
import LibraryView from "./LibraryView";
import PoetsPreview from "./PoetsPreview";

type Page = "home" | "library" | "editorial";

type NavigationItem = {
  label: string;
  icon: typeof House;
  page?: Page;
};

const navigation: NavigationItem[] = [
  { label: "Ekran główny", icon: House, page: "home" },
  { label: "Edukacja", icon: GraduationCap },
  { label: "Biblioteka", icon: LibraryBig, page: "library" },
  { label: "Ulubione", icon: Heart },
  { label: "Szukaj", icon: Search },
];

function SectionHeading({
  id,
  title,
  description,
  icon: Icon,
}: {
  id?: string;
  title: string;
  description?: string;
  icon?: typeof BookOpen;
}) {
  return (
    <div className="section-heading">
      <div>
        <h2 id={id}>{title}</h2>
        {description ? <p>{description}</p> : null}
      </div>
      {Icon ? (
        <span className="section-heading-icon" aria-hidden="true">
          <Icon size={19} strokeWidth={1.7} />
        </span>
      ) : null}
    </div>
  );
}

function EmptyCollection({ children }: { children: string }) {
  return (
    <div className="empty-collection">
      <span className="empty-collection-mark" aria-hidden="true">
        <BookOpen size={21} strokeWidth={1.6} />
      </span>
      <p>{children}</p>
    </div>
  );
}

function BottomNavigation({ currentPage }: { currentPage: Page }) {
  return (
    <nav className="bottom-navigation" aria-label="Nawigacja główna">
      {navigation.map(({ label, icon: Icon, page }) => {
        const active = page === currentPage;
        return (
          <button
            className={`nav-item${active ? " nav-item-active" : ""}`}
            type="button"
            key={label}
            aria-current={active ? "page" : undefined}
            disabled={!page}
            onClick={() => {
              if (page) {
                window.location.assign(page === "home" ? "/" : "/biblioteka");
              }
            }}
            title={page ? label : `${label} - kolejny etap`}
          >
            <Icon size={22} strokeWidth={active ? 2 : 1.7} aria-hidden="true" />
            <span>{label}</span>
          </button>
        );
      })}
    </nav>
  );
}

export default function App() {
  const pathname = window.location.pathname;
  const currentPage: Page =
    pathname === "/" ? "home" : pathname === "/biblioteka" ? "library" : "editorial";

  return (
    <div className="app-shell">
      <header className="top-bar">
        <a className="wordmark" href="/" aria-label="Poetry App - ekran główny">
          <span className="wordmark-symbol" aria-hidden="true">
            <BookOpen size={20} strokeWidth={1.8} />
          </span>
          <span>poetry<span className="wordmark-light">app</span></span>
        </a>
        <span className="top-note">Przestrzeń dla słowa</span>
      </header>

      {currentPage === "home" ? (
        <main className="home-content">
        <section className="welcome-block" aria-labelledby="welcome-title">
          <p className="eyebrow">CHWILA DLA POEZJI</p>
          <h1 id="welcome-title">Zatrzymaj się na chwilę.</h1>
          <p className="welcome-copy">
            Posłuchaj słowa. Odkryj jego brzmienie.
          </p>
        </section>

        <section className="today-section" aria-labelledby="today-title">
          <SectionHeading
            id="today-title"
            title="Wiersz na dziś"
            description="Jedno nagranie, któremu możesz poświęcić chwilę."
            icon={Sparkles}
          />
          <FeaturedVideoCard />
        </section>

        <section className="collection-section" aria-labelledby="poets-title">
          <SectionHeading
            id="poets-title"
            title="Poeci"
            description="Poznaj ludzi i słowa stojące za utworami."
            icon={BookOpen}
          />
          <PoetsPreview />
        </section>

        <section className="collection-section" aria-labelledby="artists-title">
          <SectionHeading
            id="artists-title"
            title="Artyści"
            description="Odkrywaj różne głosy i interpretacje."
            icon={UsersRound}
          />
          <div className="collection-placeholder">
            <EmptyCollection>
              Katalog artystów pojawi się po podłączeniu biblioteki nagrań.
            </EmptyCollection>
          </div>
        </section>

        <section className="collection-section recommended-section" aria-labelledby="recommended-title">
          <SectionHeading
            id="recommended-title"
            title="Wybrane dla Ciebie"
            description="Miejsce na kolejne odkrycia."
            icon={Heart}
          />
          <div className="collection-placeholder">
            <EmptyCollection>
              Ta sekcja zostanie wypełniona na podstawie rzeczywistych materiałów.
            </EmptyCollection>
          </div>
        </section>
        </main>
      ) : currentPage === "library" ? (
        <LibraryView />
      ) : (
        <EditorialPages pathname={pathname} />
      )}

      <footer className="site-footer">
        <span className="footer-mark" aria-hidden="true">p.</span>
        <p>Nie trzeba się spieszyć. Wystarczy posłuchać.</p>
      </footer>

      <BottomNavigation currentPage={currentPage} />
    </div>
  );
}
