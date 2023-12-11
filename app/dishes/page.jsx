"use client";
import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/DeleteOutlined";
import SaveIcon from "@mui/icons-material/Save";
import CancelIcon from "@mui/icons-material/Close";
import Tab from '@mui/material/Tab';
import TabContext from '@mui/lab/TabContext';
import TabList from '@mui/lab/TabList';
import TabPanel from '@mui/lab/TabPanel';
import Table from "@components/Table";
import {
  GridRowModes,
  DataGrid,
  GridToolbarContainer,
  GridActionsCellItem,
  GridRowEditStopReasons,
} from "@mui/x-data-grid";
import {
  randomCreatedDate,
  randomTraderName,
  randomId,
  randomArrayItem,
} from "@mui/x-data-grid-generator";
import { CircularProgress, Typography } from "@mui/material";

function EditToolbar(props) {
  const { setRows, setRowModesModel } = props;

  const handleClick = () => {
    const id = randomId();
    setRows((oldRows) => [...oldRows, { id, name: "", age: "", isNew: true }]);
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [id]: { mode: GridRowModes.Edit, fieldToFocus: "name" },
    }));
  };

  return (
    <GridToolbarContainer>
      <Button color="primary" startIcon={<AddIcon />} onClick={handleClick}>
        Add record
      </Button>
    </GridToolbarContainer>
  );
}

export default function DishesPage() {
  const [rows, setRows] = React.useState([]);
  const [discountDish, setDiscountDish] = React.useState([])
  const [rowModesModel, setRowModesModel] = React.useState({});
  const [loading, setLoading] = React.useState(true);
  const [tabValue, setTabValue] = React.useState("1");

  const handleChange = (event, newValue) => {
    setTabValue(newValue);
  };

  React.useEffect(() => {
    const fetchStaffs = async () => {
      const res = await fetch(`api/dishes`);
      const data = await res.json();
      setRows(data);
      setLoading(false);
      const discount = await fetch(`api/dishes/discount/2023-09-01`);
      const discountData = await discount.json();
      discountData.map((item, index) => {
        item.ID = index + 1
      })
      console.log(discountData);
      setDiscountDish(discountData);
    };

    fetchStaffs();
  }, []);

  const handleRowEditStop = (params, event) => {
    if (params.reason === GridRowEditStopReasons.rowFocusOut) {
      event.defaultMuiPrevented = true;
    }
  };

  const handleEditClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.Edit } });
  };

  const handleSaveClick = (id) => () => {
    setRowModesModel({ ...rowModesModel, [id]: { mode: GridRowModes.View } });
  };

  const handleDeleteClick = (id) => () => {
    setRows(rows.filter((row) => row.id !== id));
  };

  const handleCancelClick = (id) => () => {
    setRowModesModel({
      ...rowModesModel,
      [id]: { mode: GridRowModes.View, ignoreModifications: true },
    });

    const editedRow = rows.find((row) => row.id === id);
    if (editedRow.isNew) {
      setRows(rows.filter((row) => row.id !== id));
    }
  };

  const processRowUpdate = (newRow) => {
    const updatedRow = { ...newRow, isNew: false };
    setRows(rows.map((row) => (row.id === newRow.id ? updatedRow : row)));
    return updatedRow;
  };

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel);
  };

  const columns = [
    {
      field: "Dish_ID",
      headerName: "ID",
      type: "string",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    { field: "Price", headerName: "Price", type: "number", width: 80, editable: true },
    {
      field: "Category",
      headerName: "Category",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Dname",
      headerName: "Name",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Thumbnail",
      headerName: "Thumbnail",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "actions",
      type: "actions",
      headerName: "Actions",
      width: 100,
      cellClassName: "actions",
      getActions: ({ id }) => {
        const isInEditMode = rowModesModel[id]?.mode === GridRowModes.Edit;

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label="Save"
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(id)}
            />,
            <GridActionsCellItem
              icon={<CancelIcon />}
              label="Cancel"
              className="textPrimary"
              onClick={handleCancelClick(id)}
              color="inherit"
            />,
          ];
        }

        return [
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Edit"
            className="textPrimary"
            onClick={handleEditClick(id)}
            color="inherit"
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            onClick={handleDeleteClick(id)}
            color="inherit"
          />,
        ];
      },
    },
  ];

  const discountColumns = [
    {
      field: "Dish",
      headerName: "Name",
      type: "string",
      width: 400,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    { field: "Origin_price", headerName: "Price", type: "number", width: 300, editable: true },
    {
      field: "Discount_price",
      headerName: "Price after discount",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
  ];

  return (
    <Box
      className="mt-20 mx-2"
      sx={{
        height: 500,
        width: "100%",
        "& .actions": {
          color: "text.secondary",
        },
        "& .textPrimary": {
          color: "text.primary",
        },
      }}
    >
      <Typography variant="h5" color="text.primary" align="left" my={2}>
        Quản lí món ăn
      </Typography>
      <Box sx={{ width: "100%", typography: "body1" }}>
        <TabContext value={tabValue}>
          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <TabList onChange={handleChange} aria-label="lab API tabs example">
              <Tab label="All" value="1" />
              <Tab label="Discount" value="2" />
            </TabList>
          </Box>
          <TabPanel value="1">
            {loading ? (
              <CircularProgress />
            ) : (
              <Table
                rows={rows}
                setRows={setRows}
                columns={columns}
                rowModesModel={rowModesModel}
                setRowModesModel={setRowModesModel}
                handleRowModesModelChange={handleRowModesModelChange}
                handleRowEditStop={handleRowEditStop}
                processRowUpdate={processRowUpdate}
                idField="Dish_ID"
                EditToolbar={EditToolbar}
              />
            )}
          </TabPanel>
          <TabPanel value="2">
            {loading ? (
              <CircularProgress />
            ) : (
              <Table
                rows={discountDish}
                setRows={setDiscountDish}
                columns={discountColumns}
                rowModesModel={rowModesModel}
                setRowModesModel={setRowModesModel}
                handleRowModesModelChange={handleRowModesModelChange}
                handleRowEditStop={handleRowEditStop}
                processRowUpdate={processRowUpdate}
                idField="ID"
                // EditToolbar={EditToolbar}
              />
            )}
          </TabPanel>
        </TabContext>
      </Box>
    </Box>
  );
}
