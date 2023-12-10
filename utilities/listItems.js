import * as React from 'react';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import ListSubheader from '@mui/material/ListSubheader';
import DashboardIcon from '@mui/icons-material/Dashboard';
import ShoppingCartIcon from '@mui/icons-material/ShoppingCart';
import PeopleIcon from '@mui/icons-material/People';
import BarChartIcon from '@mui/icons-material/BarChart';
import LayersIcon from '@mui/icons-material/Layers';
import AssignmentIcon from '@mui/icons-material/Assignment';
import RestaurantMenuIcon from '@mui/icons-material/RestaurantMenu';

export const mainListItems = (
  <React.Fragment>
    <ListItemButton href='/'>
      <ListItemIcon>
        <DashboardIcon />
      </ListItemIcon>
      <ListItemText primary="Trang chủ" />
    </ListItemButton>
    <ListItemButton href='/billing'>
      <ListItemIcon>
        <ShoppingCartIcon />
      </ListItemIcon>
      <ListItemText primary="Hóa đơn" />
    </ListItemButton>
    <ListItemButton href='/bill-dish'>
      <ListItemIcon>
        <ShoppingCartIcon />
      </ListItemIcon>
      <ListItemText primary="Phục vụ" />
    </ListItemButton>
    <ListItemButton href='/ingredients'>
      <ListItemIcon>
        <PeopleIcon />
      </ListItemIcon>
      <ListItemText primary="Nguyên liệu" />
    </ListItemButton>
    <ListItemButton href='/staffs'>
      <ListItemIcon>
        <BarChartIcon />
      </ListItemIcon>
      <ListItemText primary="Nhân viên" />
    </ListItemButton>
    <ListItemButton href='/table'>
      <ListItemIcon>
        <LayersIcon />
      </ListItemIcon>
      <ListItemText primary="Bàn ăn" />
    </ListItemButton>
    <ListItemButton href='/dishes'>
      <ListItemIcon>
        <RestaurantMenuIcon />
      </ListItemIcon>
      <ListItemText primary="Món ăn" />
    </ListItemButton>
  </React.Fragment>
);
