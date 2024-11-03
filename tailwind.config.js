/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./pkg/views/**/*.{html,js,templ}"],
  theme: {
    extend: {},
    fontFamily: {
      sans: ["Inter", "sans-serif"],
    },
  },
  plugins: [],
};
