import "leaflet/dist/leaflet.css";

import React from "react";
import { createRoot } from "react-dom/client";
import { CRS, LatLngBoundsExpression, LatLngTuple } from "leaflet";
import {
  MapContainer,
  ImageOverlay,
  Popup,
  Marker,
  useMap,
} from "react-leaflet";

const width = 2376;
const height = 3888;

const topLeft2latLong = (top, left, w, h) => {
  const long = left + w / 2;
  const lat = height - (top + h / 2);

  const result: LatLngTuple = [lat, long];
  return result;
};

var bounds: LatLngBoundsExpression = [
  [0, 0],
  [height, width],
];

const HandleExfiltrator = () => {
  window.map = useMap();

  return <></>;
};

interface MapProps {
  style?: React.CSSProperties;
}

const Map: React.FC<MapProps> = (props: MapProps) => {
  return (
    <MapContainer
      crs={CRS.Simple}
      zoom={-2.3}
      bounds={bounds}
      minZoom={-2.5}
      zoomDelta={0.5}
      zoomSnap={0.01}
      scrollWheelZoom={true}
      style={props.style}
      maxBounds={bounds}
    >
      <ImageOverlay
        bubblingMouseEvents={true}
        bounds={[
          topLeft2latLong(-110.244575, 3.334838, 0, 0),
          topLeft2latLong(
            -110.244575,
            3.334838,
            2358.678484 * 2,
            4108.677283 * 2
          ),
        ]}
        url="/images/map.png"
      />

      <HandleExfiltrator />
      {/* <Marker position={topLeft2latLong(553.6392, 1855.9875, 32.616, 49.968)}>
        <Popup>Office Depot</Popup>
      </Marker> */}
    </MapContainer>
  );
};

const mountMap = (element) => {
  const mapMount = createRoot(element);
  mapMount.render(
    <React.StrictMode>
      <Map
        style={{
          flexBasis: "100%",
          flexGrow: "1",
        }}
      />
    </React.StrictMode>
  );

  return map;
};

window.mountMap = mountMap;
