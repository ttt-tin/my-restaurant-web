"use client";
import * as React from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import AddIcon from "@mui/icons-material/Add";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/DeleteOutlined";
import SaveIcon from "@mui/icons-material/Save";
import CancelIcon from "@mui/icons-material/Close";
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
  const { setRows, numberIDs, setNumberIDs, setRowModesModel } = props;

  const handleClick = () => {
    let newId = 0
    setRows((oldRows) => {newId = oldRows.length+1; return [...oldRows, { Staff_ID: oldRows.length+1, Staff_name: "", Staff_address: "", Sphone: "", Sex: "", Area_name: "", isNew: true }]});
    setRowModesModel((oldModel) => ({
      ...oldModel,
      [newId]: { mode: GridRowModes.Edit, fieldToFocus: "Staff_name" },
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

const updateStaff = async (row) => {
  try {
    const res = await fetch(`api/staffs`, {
      method: 'PUT',
      body: JSON.stringify({
        Staff_ID: row.Staff_ID,
        Staff_address: row.Staff_address, 
        Sphone: row.Sphone, 
        Staff_name: row.Staff_name, 
        Area_name: row.Area_name
      })
    }).then((response) => console.log(response))
  } catch (error) {
    console.log(error);
  }
}

export default function StaffPage() {
  const [rows, setRows] = React.useState([]);
  const [numberIDs, setNumberIDs] = React.useState(0);
  const [rowModesModel, setRowModesModel] = React.useState({});
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    const fetchStaffs = async () => {
      const res = await fetch(`api/staffs`);
      const data = await res.json();

      setRows(data);
      console.log(data.length);
      setNumberIDs(data.length);
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
    setRows(rows.filter((row) => row.Staff_ID !== id));
    deleteStaff(id);
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
    if (numberIDs + 1 == Number(newRow.Staff_ID)) {
      addNewStaff(newRow);
      setNumberIDs(numberIDs => numberIDs + 1);
    }
    else {
      updateStaff(newRow);
    }
    const updatedRow = { ...newRow, isNew: false };
    setRows(rows.map((row) => (row.Staff_ID === newRow.Staff_ID ? updatedRow : row)));
    return updatedRow;
  };

  const handleRowModesModelChange = (newRowModesModel) => {
    setRowModesModel(newRowModesModel);
  };

  const columns = [
    {
      field: "Staff_ID",
      headerName: "ID",
      type: "string",
      width: 80,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    { field: "Staff_name", headerName: "Name", width: 180, editable: true },
    {
      field: "Staff_address",
      headerName: "Address",
      type: "string",
      width: 200,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Sphone",
      headerName: "Phone",
      type: "string",
      width: 150,
      align: "left",
      headerAlign: "left",
      editable: true,
    },
    {
      field: "Sex",
      headerName: "Sex",
      type: "singleSelect",
      width: 80,
      align: "left",
      headerAlign: "left",
      valueOptions: ["Nam", "Nữ"],
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
        const isInEditMode = rowModesModel[row.Staff_ID]?.mode === GridRowModes.Edit;

        if (isInEditMode) {
          return [
            <GridActionsCellItem
              icon={<SaveIcon />}
              label="Save"
              sx={{
                color: "primary.main",
              }}
              onClick={handleSaveClick(row.Staff_ID)}
            />,
            <GridActionsCellItem
              icon={<CancelIcon />}
              label="Cancel"
              className="textPrimary"
              onClick={handleCancelClick(row.Staff_ID)}
              color="inherit"
            />,
          ];
        }

        return [
          <GridActionsCellItem
            icon={<EditIcon />}
            label="Edit"
            className="textPrimary"
            onClick={handleEditClick(row.Staff_ID)}
            color="inherit"
          />,
          <GridActionsCellItem
            icon={<DeleteIcon />}
            label="Delete"
            onClick={handleDeleteClick(row.Staff_ID)}
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
        <Typography variant="h5" color="text.primary" align="left" my={2}>Quản lí nhân viên</Typography>
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
            toolbar: { setRows, numberIDs, setNumberIDs, setRowModesModel },
          }}
          getRowId={(row) => row.Staff_ID}
        />
      )}
    </Box>
  );
}
