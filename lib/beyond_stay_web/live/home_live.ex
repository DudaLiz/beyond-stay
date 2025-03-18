defmodule BeyondStayWeb.Live.HomeLive do
  use BeyondStayWeb, :live_view

  @image_interval 5000 # Auto-scroll interval in milliseconds

  def mount(_params, _session, socket) do
    images = [
      %{url: "/images/stay1.jpg", description: "Relaxing pet-friendly stay"},
      %{url: "/images/stay2.jpg", description: "Your poolside office"},
      %{url: "/images/stay3.jpg", description: "Your home in Valencia"}
    ]

    reviews = [
      "Amazing experience! Highly recommend!",
      "Loved every moment of our stay.",
      "Perfect getaway with my pet!"
    ]

    # Start auto-scroll
    if connected?(socket), do: :timer.send_interval(@image_interval, self(), :next_image)

    {:ok, assign(socket, images: images, reviews: reviews, current_index: 0, current_review: 0)}
  end

  def handle_info(:next_image, socket) do
    new_index = rem(socket.assigns.current_index + 1, length(socket.assigns.images))
    {:noreply, assign(socket, current_index: new_index)}
  end

  def handle_event("next_image", _params, socket) do
    new_index = rem(socket.assigns.current_index + 1, length(socket.assigns.images))
    {:noreply, assign(socket, current_index: new_index)}
  end

  def handle_event("next_review", _params, socket) do
    new_index = rem(socket.assigns.current_review + 1, length(socket.assigns.reviews))
    {:noreply, assign(socket, current_review: new_index)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4 bg-[#F5F5F5] text-[#333333]">
      <header class="text-center text-3xl font-extrabold text-[#146ebb] py-6">
        Beyond Stay
      </header>

      <!-- Carousel with Placeholder Intro -->
      <div class="relative my-6 flex items-center justify-center">
        <div class="relative w-3/5">
          <div class="overflow-hidden rounded-lg shadow-lg">
            <div class="flex transition-all duration-300" style={"transform: translateX(-#{@current_index * 100}%)"}>
              <%= for image <- @images do %>
                <div class="w-full flex-shrink-0 relative">
                  <img src={image.url} alt={image.description} class="w-full h-64 object-cover">
                  <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center text-white text-lg p-4">
                    <p><%= image.description %></p>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
        <div class="w-2/5 p-6 bg-[#146ebb] bg-opacity-50 text-white rounded-lg">
          <h2 class="text-2xl font-bold">Welcome to Beyond Stay</h2>
          <p class="mt-2">Discover your perfect home away from home with us, for digital nomads, travellers with pets, and the perfect retreat while you look for your forever home in Valencia.</p>
        </div>
      </div>

      <!-- Book a Stay -->
      <div class="grid grid-cols-2 gap-6 my-6">
        <div class="p-6 bg-[#63aac0] rounded-lg text-center">
          <h2 class="text-xl font-bold text-white">Book a Stay</h2>
          <lable>Select a Room Type</lable>
          <select> 
            <option value="single">Single Room</option>
            <option value="double">Double Room</option>
            <option value="double_ac">Double Romm w/ Airconditioning</option>
          </select>
          <lable>How many people will stay in the room</lable>
          <input type="number" min="1" max="2">
          <lable>Are you bringing any pets?</lable>
          <input type="number" min="0" max="5">
          <lable>When you would like to book for?</lable>
          <input type="date">
          <button class="bg-[#fbcd40] text-white px-4 py-2 rounded-full shadow-md hover:bg-[#eb6868] transition duration-300">Reserve</button>
        </div>

      <!-- Book a Pet Stay -->
        <div class="p-6 bg-[#63aac0] rounded-lg text-center">
          <h2 class="text-xl font-bold text-white">Book a Pet Stay</h2>
          <lable>Select a Service</lable>
          <select> 
            <option value="boarding">Boarding</option>
            <option value="daycare">Day Care</option>
            <option value="walk">Walk</option>
          </select>
          <lable for="quantity">How many pets is this service for?</lable>
          <input type="number" id="quantity" name="quantity" min="1" max="5">
          <lable>What type of pet are you booking for?</lable>
          <select>
          <option>Dog</option>
          <option>Cat</option> 
          <option>Other</option>
          </select>
          <lable>What dates do you want to book for?</lable>
          <input type="date">
          <button class="bg-[#fbcd40] text-white px-4 py-2 rounded-full shadow-md hover:bg-[#eb6868] transition duration-300">Reserve</button>
        </div>
      </div>

      <!-- Guest Reviews -->
      <div class="reviews text-center my-6">
        <h2 class="text-2xl font-bold text-[#146ebb] mb-4">Guest Reviews</h2>
        <p class="text-lg text-[#333333] italic"><%= Enum.at(@reviews, @current_review, "No reviews available") %></p>
        <button phx-click="next_review" class="bg-[#04d8fe] text-white px-6 py-3 rounded-full shadow-md hover:bg-[#9859e6] transition duration-300 mt-4">
          Next Review
        </button>
      </div>

      <!-- Footer -->
      <footer class="text-center py-6 bg-[#146ebb] text-white">
        <p class="text-sm">
          Contact Us | Privacy Policy
        </p>
      </footer>
    </div>
    """
  end
end
