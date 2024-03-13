import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["carousel"];

  connect() {
    this.carouselTarget.addEventListener("mousedown", this.dragStart.bind(this));
    this.carouselTarget.addEventListener("mousemove", this.dragging.bind(this));
    document.addEventListener("mouseup", this.dragStop.bind(this));
    this.carouselTarget.addEventListener("scroll", this.infiniteScroll.bind(this));
    this.wrapperTarget.addEventListener("mouseenter", () => clearTimeout(this.timeoutId));
    this.wrapperTarget.addEventListener("mouseleave", this.autoPlay.bind(this));

    // Initialize autoplay
    this.autoPlay();
  }

  dragStart(event) {
    this.isDragging = true;
    this.carouselTarget.classList.add("dragging");
    this.startX = event.pageX;
    this.startScrollLeft = this.carouselTarget.scrollLeft;
  }

  dragging(event) {
    if (!this.isDragging) return;
    this.carouselTarget.scrollLeft = this.startScrollLeft - (event.pageX - this.startX);
  }

  dragStop() {
    this.isDragging = false;
    this.carouselTarget.classList.remove("dragging");
  }

  infiniteScroll() {
    if (this.carouselTarget.scrollLeft === 0) {
      this.carouselTarget.classList.add("no-transition");
      this.carouselTarget.scrollLeft = this.carouselTarget.scrollWidth - 2 * this.carouselTarget.offsetWidth;
      this.carouselTarget.classList.remove("no-transition");
    } else if (Math.ceil(this.carouselTarget.scrollLeft) === this.carouselTarget.scrollWidth - this.carouselTarget.offsetWidth) {
      this.carouselTarget.classList.add("no-transition");
      this.carouselTarget.scrollLeft = this.carouselTarget.offsetWidth;
      this.carouselTarget.classList.remove("no-transition");
    }
    clearTimeout(this.timeoutId);
    if (!this.wrapperTarget.matches(":hover")) this.autoPlay();
  }

  autoPlay() {
    if (window.innerWidth < 800 || !this.isAutoPlay) return;
    this.timeoutId = setTimeout(() => (this.carouselTarget.scrollLeft += this.firstCardWidth), 2500);
  }

  get carouselTarget() {
    return this.targets.find("carousel");
  }

  get wrapperTarget() {
    return this.targets.find("wrapper");
  }
}
