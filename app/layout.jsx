import Nav from "@components/Nav";
import "@styles/globals.css";
import ThemeRegistry from "@styles/theme/themeRegistry";
import { Box } from "@mui/material";

export const metadata = {
  title: "My restaurant",
  description: "An restaurant web with sql database",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <ThemeRegistry options={{ key: 'mui' }}>
        <Box sx={{ display: 'flex' }}>
          <Nav />
          {children}
        </Box>
        </ThemeRegistry>
      </body>
    </html>
  );
}
