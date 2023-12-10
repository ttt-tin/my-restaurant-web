"use client";
import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/DeleteOutlined";
import SaveIcon from "@mui/icons-material/Save";
import CancelIcon from "@mui/icons-material/Close";
import {TextField} from "@mui/material";
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
    let newId = 0
    setRows((oldRows) => {newId = oldRows.length+1; return [...oldRows, { Table_ID: newId, number_of_chairs: 0, Status: "Sẵn sàng", Max_People: 0, Min_people: 0, Area_name: "", isNew: true }]});
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [newId]: { mode: GridRowModes.Edit, fieldToFocus: "number_of_chairs" },
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

const addNewStaff = async (row) => {
  try {
    const res = await fetch(`api/staffs`, {
      method: 'POST',
      body: JSON.stringify({
        Staff_name: row.Staff_name, 
        Staff_address: row.Staff_address, 
        Sphone: row.Sphone, 
        Sex: row.Sex, 
        Area_name: row.Area_name
      })
    })
  } catch (error) {
    console.log(error);
  }
}

const deleteStaff = async (id) => {
  try {
    const res = await fetch(`api/staffs`, {
      method: 'DELETE',
      body: JSON.stringify({
        Staff_ID: id,
      })
    })
  } catch (error) {
    console.log(error);
  }
}

export default function TablePage() {
  const [rows, setRows] = React.useState([]);
  const [rowModesModel, setRowModesModel] = React.useState({});
  const [loading, setLoading] = React.useState(true);
  const [findValue, setFindValue] = React.useState("");

  React.useEffect(() => {
    const fetchStaffs = async () => {
      const res = await fetch(`api/table`);
      const data = await res.json();

      setRows(data);
      setLoading(false);
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
    deleteStaff(id);
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
    if (rows.length===newRow.Table_ID) {
      addNewStaff(newRow);
    }
    const updatedRow = { ...newRow, isNew: false };
    setRows(rows.map((row) => (row.Table_ID === newRow.Table_ID ? updatedRow : row)));
    return updatedRow;
  };

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel);
  };

  const columns = [
    {
      field: "Table_ID",
      headerName: "ID",
      type: "string",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    { field: "Number_of_chairs", headerName: "Chairs", align: "left", headerAlign: "left", type: "number", width: 80, editable: true },
    {
      field: "Status",
      headerName: "Status",
      type: "singleSelect",
      width: 200,
      align: "left",
      valueOptions: ["Sẵn sàng", "Không sẵn sàng"],
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Max_People",
      headerName: "Max people",
      type: "number",
      width: 100,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Min_people",
      headerName: "Min people",
      type: "number",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Area_name",
      headerName: "Area",
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
      getActions: ({row}) => {
        const isInEditMode = rowModesModel[row.Table_ID]?.mode === GridRowModes.Edit;

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label="Save"
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(row.Table_ID)}
            />,
            <GridActionsCellItem
              icon={<CancelIcon />}
              label="Cancel"
              className="textPrimary"
              onClick={handleCancelClick(row.Table_ID)}
              color="inherit"
            />,
          ];
        }

        return [
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Edit"
            className="textPrimary"
            onClick={handleEditClick(row.Table_ID)}
            color="inherit"
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            onClick={handleDeleteClick(row.Table_ID)}
            color="inherit"
          />,
        ];
      },
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
        <Typography variant="h5" color="text.primary" align="left" my={2}>Quản lí bàn</Typography>
        <Typography className="ml-3" variant="h8" color="text.primary" align="left" my={2}>Kiểm tra bàn trống</Typography>
        <TextField value={findValue} onChange={(e) => {setFindValue(e.target.value); console.log(findValue)}} id="outlined-basic" label="ID" variant="outlined" size="small"/>
      {loading ? (
        <CircularProgress />
      ) : (
        <DataGrid
          rows={rows}
          columns={columns}
          editMode="row"
          rowModesModel={rowModesModel}
          onRowModesModelChange={handleRowModesModelChange}
          onRowEditStop={handleRowEditStop}
          processRowUpdate={processRowUpdate}
          slots={{
            toolbar: EditToolbar,
          }}
          slotProps={{
            toolbar: { setRows, setRowModesModel },
          }}
          getRowId={(row) => row.Table_ID}
        />
      )}
    </Box>
  );
}
