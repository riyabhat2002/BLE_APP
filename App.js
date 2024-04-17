// // import { StatusBar } from 'expo-status-bar';
// // import { StyleSheet, Text, View } from 'react-native';
// // import React, { useState } from 'react';
// // import { AppBar, Tabs, Tab, Box, Typography, Slider, Card, CardContent } from '@mui/material';

// //-----------------------------------------------------------------------
// // export default function App() {
// //   return (
// //     <View style={styles.container}>
// //       <Text>Open up App.js to start working on your app!</Text>
// //       <StatusBar style="auto" />
// //     </View>
// //   );
// // }

// // const styles = StyleSheet.create({
// //   container: {
// //     flex: 1,
// //     backgroundColor: '#fff',
// //     alignItems: 'center',
// //     justifyContent: 'center',
// //   },
// // });


// //------------------------------------------------------------------------
// // export default function App() {
// //   // Placeholder values for environmental data
// //   const environmentData = {
// //     temperature: '24°C',
// //     humidity: '50%',
// //     pressure: '1013 hPa'
// //   };

// //   return (
// //     <View style={styles.container}>
// //       <Text style={styles.title}>Smart Farm</Text>
// //       <View style={styles.dashboard}>
// //         <View style={styles.sensor}>
// //           <Text style={styles.sensorTitle}>Temperature</Text>
// //           <Text style={styles.sensorValue}>{environmentData.temperature}</Text>
// //         </View>
// //         <View style={styles.sensor}>
// //           <Text style={styles.sensorTitle}>Humidity</Text>
// //           <Text style={styles.sensorValue}>{environmentData.humidity}</Text>
// //         </View>
// //         <View style={styles.sensor}>
// //           <Text style={styles.sensorTitle}>Pressure</Text>
// //           <Text style={styles.sensorValue}>{environmentData.pressure}</Text>
// //         </View>
// //       </View>
// //       {/* Add controls here */}
// //       <StatusBar style="auto" />
// //     </View>
// //   );
// // }

// // const styles = StyleSheet.create({
// //   container: {
// //     flex: 1,
// //     backgroundColor: '#fff',
// //     justifyContent: 'center',
// //     padding: 20,
// //   },
// //   title: {
// //     fontSize: 32,
// //     fontWeight: 'bold',
// //     textAlign: 'center',
// //     margin: 20,
// //   },
// //   dashboard: {
// //     flexDirection: 'row',
// //     justifyContent: 'space-around',
// //     alignItems: 'center',
// //   },
// //   sensor: {
// //     alignItems: 'center',
// //   },
// //   sensorTitle: {
// //     fontSize: 20,
// //     fontWeight: 'bold',
// //   },
// //   sensorValue: {
// //     fontSize: 18,
// //   },
// //   // Add styles for controls here
// // });
// /****************************************************************************/
// // function TabPanel(props) {
// //   const { children, value, index, ...other } = props;

// //   return (
// //     <div
// //       role="tabpanel"
// //       hidden={value !== index}
// //       id={`simple-tabpanel-${index}`}
// //       aria-labelledby={`simple-tab-${index}`}
// //       {...other}
// //     >
// //       {value === index && (
// //         <Box p={3}>
// //           <Typography component="div">{children}</Typography>
// //         </Box>
// //       )}
// //     </div>
// //   );
// // }

// // function a11yProps(index) {
// //   return {
// //     id: `simple-tab-${index}`,
// //     'aria-controls': `simple-tabpanel-${index}`,
// //   };
// // }

// // export default function App() {
// //   const [value, setValue] = useState(0);
// //   const [environment, setEnvironment] = useState({
// //     temperature: 24,
// //     humidity: 50,
// //     pressure: 1013,
// //   });

// //   const handleChange = (event, newValue) => {
// //     setValue(newValue);
// //   };

// //   const handleEnvironmentChange = (name) => (event, newValue) => {
// //     setEnvironment({ ...environment, [name]: newValue });
// //   };

// //   return (
// //     <Box sx={{ width: '100%' }}>
// //       <AppBar position="static">
// //         <Tabs value={value} onChange={handleChange} aria-label="environment tabs">
// //           <Tab label="Readings" {...a11yProps(0)} />
// //           <Tab label="Controls" {...a11yProps(1)} />
// //         </Tabs>
// //       </AppBar>
// //       <TabPanel value={value} index={0}>
// //         {/* Readings display */}
// //         <Box display="flex" justifyContent="space-around" flexWrap="wrap">
// //           <Card sx={{ minWidth: 275, margin: 2 }}>
// //             <CardContent>
// //               <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
// //                 Temperature
// //               </Typography>
// //               <Typography variant="h5" component="div">
// //                 {environment.temperature} °C
// //               </Typography>
// //             </CardContent>
// //           </Card>
// //           <Card sx={{ minWidth: 275, margin: 2 }}>
// //             <CardContent>
// //               <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
// //                 Humidity
// //               </Typography>
// //               <Typography variant="h5" component="div">
// //                 {environment.humidity}%
// //               </Typography>
// //             </CardContent>
// //           </Card>
// //           <Card sx={{ minWidth: 275, margin: 2 }}>
// //             <CardContent>
// //               <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
// //                 Pressure
// //               </Typography>
// //               <Typography variant="h5" component="div">
// //                 {environment.pressure} hPa
// //               </Typography>
// //             </CardContent>
// //           </Card>
// //         </Box>
// //       </TabPanel>
// //       <TabPanel value={value} index={1}>
// //         {/* Controls for adjustment */}
// //         <Box display="flex" flexDirection="column" alignItems="center">
// //           <Typography id="temperature-slider" gutterBottom>
// //             Temperature (°C)
// //           </Typography>
// //           <Slider
// //             value={environment.temperature}
// //             onChange={handleEnvironmentChange('temperature')}
// //             aria-labelledby="temperature-slider"
// //             min={10}
// //             max={30}
// //           />
// //           <Typography id="humidity-slider" gutterBottom>
// //             Humidity (%)
// //           </Typography>
// //           <Slider
// //             value={environment.humidity}
// //             onChange={handleEnvironmentChange('humidity')}
// //             aria-labelledby="humidity-slider"
// //             min={0}
// //             max={100}
// //           />
// //           <Typography id="pressure-slider" gutterBottom>
// //             Pressure (hPa)
// //           </Typography>
// //           <Slider
// //             value={environment.pressure}
// //             onChange={handleEnvironmentChange('pressure')}
// //             aria-labelledby="pressure-slider"
// //             min={950}
// //             max={1050}
// //           />
// //         </Box>
// //       </TabPanel>
// //     </Box>
// //   );
// // }

// import React, { useState } from 'react';
// import { Box, Typography, Slider, Paper, Grid, AppBar, Toolbar, createTheme, ThemeProvider } from '@mui/material';

// // Create a theme instance.
// const theme = createTheme({
//   palette: {
//     primary: {
//       main: '#4caf50',
//     },
//     secondary: {
//       main: '#ff9100',
//     },
//   },
// });

// function App() {
//   const [sensorValues, setSensorValues] = useState({
//     temperature: 24,
//     humidity: 50,
//     pressure: 1013,
//   });

//   const handleSliderChange = (sensor, newValue) => {
//     setSensorValues((prevValues) => ({ ...prevValues, [sensor]: newValue }));
//   };

//   return (
//     <ThemeProvider theme={theme}>
//       <Box sx={{ flexGrow: 1 }}>
//         <AppBar position="static" color="primary" sx={{ alignItems: 'center' }}>
//           <Toolbar>
//             <Typography variant="h3" component="h1" sx={{ flexGrow: 1, textAlign: 'center' }}>
//               Smart Farm
//             </Typography>
//           </Toolbar>
//         </AppBar>
//         <Grid container spacing={2} padding={2}>
//           <Grid item xs={12} md={6}>
//             <Typography variant="h5" gutterBottom>
//               Readings
//             </Typography>
//             <Paper elevation={3} sx={{ padding: 2, margin: 1, backgroundColor: '#e8f5e9' }}>
//               <Typography color="textSecondary">Temperature</Typography>
//               <Typography variant="h4">{`${sensorValues.temperature}°C`}</Typography>
//             </Paper>
//             <Paper elevation={3} sx={{ padding: 2, margin: 1, backgroundColor: '#e8f5e9' }}>
//               <Typography color="textSecondary">Humidity</Typography>
//               <Typography variant="h4">{`${sensorValues.humidity}%`}</Typography>
//             </Paper>
//             <Paper elevation={3} sx={{ padding: 2, margin: 1, backgroundColor: '#e8f5e9' }}>
//               <Typography color="textSecondary">Pressure</Typography>
//               <Typography variant="h4">{`${sensorValues.pressure} hPa`}</Typography>
//             </Paper>
//           </Grid>
//           <Grid item xs={12} md={6}>
//             <Typography variant="h5" gutterBottom>
//               Controls
//             </Typography>
//             <Box display="flex" flexDirection="column" alignItems="center">
//               <Typography id="temperature-slider" gutterBottom>
//                 Temperature: {sensorValues.temperature}°C
//               </Typography>
//               <Slider
//                 value={sensorValues.temperature}
//                 onChange={(e, val) => handleSliderChange('temperature', val)}
//                 aria-labelledby="temperature-slider"
//                 valueLabelDisplay="auto"
//                 step={1}
//                 min={10}
//                 max={30}
//               />
//               <Typography id="humidity-slider" gutterBottom>
//                 Humidity: {sensorValues.humidity}%
//               </Typography>
//               <Slider
//                 value={sensorValues.humidity}
//                 onChange={(e, val) => handleSliderChange('humidity', val)}
//                 aria-labelledby="humidity-slider"
//                 valueLabelDisplay="auto"
//                 step={1}
//                 min={0}
//                 max={100}
//               />
//               <Typography id="pressure-slider" gutterBottom>
//                 Pressure: {sensorValues.pressure} hPa
//               </Typography>
//               <Slider
//                 value={sensorValues.pressure}
//                 onChange={(e, val) => handleSliderChange('pressure', val)}
//                 aria-labelledby="pressure-slider"
//                 valueLabelDisplay="auto"
//                 step={1}
//                 min={900}
//                 max={1100}
//               />
//             </Box>
//           </Grid>
//         </Grid>
//       </Box>
//     </ThemeProvider>
//   );
// }

// export default App;


import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import Slider from '@react-native-community/slider';

const theme = {
  primary: '#4caf50',
  secondary: '#ff9100',
};

function App() {
  const [sensorValues, setSensorValues] = useState({
    temperature: 24,
    humidity: 50,
    pressure: 1013,
  });

  const handleSliderChange = (sensor, newValue) => {
    setSensorValues((prevValues) => ({ ...prevValues, [sensor]: newValue }));
  };

  return (
    <View style={styles.container}>
      <StatusBar style="auto" />
      <View style={styles.header}>
        <Text style={styles.title}>Plantd</Text>
      </View>
      <View style={styles.row}>
        <Text style={styles.heading}>Readings</Text>
        <View style={styles.card}>
          <Text style={styles.label}>Temperature</Text>
          <Text style={styles.value}>{`${sensorValues.temperature}°C`}</Text>
        </View>
        <View style={styles.card}>
          <Text style={styles.label}>Humidity</Text>
          <Text style={styles.value}>{`${sensorValues.humidity}%`}</Text>
        </View>
        <View style={styles.card}>
          <Text style={styles.label}>Pressure</Text>
          <Text style={styles.value}>{`${sensorValues.pressure} hPa`}</Text>
        </View>
      </View>
      <View style={styles.row}>
        <Text style={styles.heading}>Controls</Text>
        <Text style={styles.label}>Temperature: {sensorValues.temperature}°C</Text>
        <Slider
          style={styles.slider}
          value={sensorValues.temperature}
          onValueChange={(val) => handleSliderChange('temperature', val)}
          minimumValue={10}
          maximumValue={30}
          step={1}
        />
        <Text style={styles.label}>Humidity: {sensorValues.humidity}%</Text>
        <Slider
          style={styles.slider}
          value={sensorValues.humidity}
          onValueChange={(val) => handleSliderChange('humidity', val)}
          minimumValue={0}
          maximumValue={100}
          step={1}
        />
        <Text style={styles.label}>Pressure: {sensorValues.pressure} hPa</Text>
        <Slider
          style={styles.slider}
          value={sensorValues.pressure}
          onValueChange={(val) => handleSliderChange('pressure', val)}
          minimumValue={900}
          maximumValue={1100}
          step={1}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 20,
    backgroundColor: '#fff',
  },
  header: {
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: theme.primary,
  },
  row: {
    marginBottom: 20,
  },
  heading: {
    fontSize: 24,
    fontWeight: 'bold',
    color: theme.secondary,
    marginBottom: 10,
  },
  card: {
    backgroundColor: '#e8f5e9',
    padding: 10,
    marginVertical: 5,
    alignItems: 'center',
  },
  label: {
    fontSize: 18,
    color: 'grey',
  },
  value: {
    fontSize: 22,
    fontWeight: 'bold',
  },
  slider: {
    width: '100%',
    height: 40,
  },
});

export default App;
