import React, {useState} from 'react';
import app from '../configuration/firebase';
import 'firebase/firestore';
import Modal from 'react-bootstrap/Modal';
import Button from 'react-bootstrap/Button';
// import { Container, Col, Form, FormGroup, Label, Input, Button } from 'reactstrap';
import Form from 'react-bootstrap/Form';

import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import '../../node_modules/bootstrap/dist/css/bootstrap.min.css';

import main from '../Images/HungoverMain1.png';
import logo from '../Images/logo.png';
import registerimg from '../Images/registernow.jpg';
import donateimg from '../Images/food-donations.jpg';

import '../styles/donation-style.css';

import {usePosition} from '../hooks/usePosition';

export default function DonationForm() {

    const [donorName, setDonorName]=useState("");
    const [numberofInvitedGuests, setNumberofInvitedGuests]= useState();
    const [numberOfGuestAttended, setNumberOfGuestAttended]= useState();
    const [contactNumber, setContactNumber]= useState();
    const [email, setEmail]= useState();
    const [numberOfPlates, setNumberOfPlates] = useState();
    const [platesLeft, setPlatesLeft]= useState();
    const [typeOfFood, setTypeOfFood]= useState("");
    const [dateOfEvent, setDateOfEvent]= useState();
    const [startTimeOfEvent, setStartTimeOfEvent]= useState();
    const [endTimeOfEvent, setEndTimeOfEvent]= useState();
    const [eventBefore, setEventBefore]= useState(false);
    const [show, setShow]= useState(false);
    

    const {
        latitude,
        longitude,
        timestamp,
      } = usePosition();

    // Donate Food
    function DonateFood(e) {
        e.preventDefault();
        const db = app.firestore();
        db.collection("DonateFood").add({
            name: `${donorName}`,
            phone: contactNumber,
            email: email,
            Location: ({
                 lat: `${latitude}`,
                 long: `${longitude}`,
                 time: `${timestamp}`
            }),
            peopleInvited: `${numberofInvitedGuests}`,
            peopleTurnedUp: `${numberOfGuestAttended}`,
            platesOrdered: `${numberOfPlates}`,
            platesRemaining: `${platesLeft}`,
            typeOfFood: `${typeOfFood}`
        
        }).then((docRef) => {
            console.log("Document written with ID: ", docRef.id);
            console.log("done");
            window.location.reload();
        })
        .catch((error) => {
            console.error("Error adding document: ", error);
        });
    }
    
    //Register Event
    function RegisterEvent(e) {
        e.preventDefault();
        const db = app.firestore();
        db.collection("RegisterEvent").add({
            name: `${donorName}`,
            phone: contactNumber,
            email: email,
            Location: ({
                 lat: `${latitude}`,
                 long: `${longitude}`,
                 time: `${timestamp}`
            }),
            peopleInvited: numberofInvitedGuests,
            date: `${dateOfEvent}`,
            startTime: `${startTimeOfEvent}`,
            endTime: `${endTimeOfEvent}`,
            platesOrdered: numberOfPlates,
            typeOfFood: `${typeOfFood}`
        
        }).then((docRef) => {
            console.log("Document written with ID: ", docRef.id);
            console.log("done");
            window.location.reload();
        })
        .catch((error) => {
            console.error("Error adding document: ", error);
        });
    }

    const handleModalAfterEvent = ()=>{
        setEventBefore(false)
        setShow(true)
    }

    const handleModalBeforeEvent=()=>{
        setEventBefore(true)
        setShow(true)
    }

    return (
        <div className="main-container">
            <Navbar bg="light" variant="light" expand="lg">
                <Navbar.Brand href="#home">
                    <img 
                        src={logo} 
                        width="30" 
                        height="30" 
                        className="d-inline-block align-top"
                        alt="logo"
                    />{' '}
                    HungOver
                </Navbar.Brand>
                <Navbar.Toggle aria-controls="basic-navbar-nav" />
                <Navbar.Collapse id="basic-navbar-nav">
                    <Nav className="mr-auto">
                        <Nav.Link href="#home">Home</Nav.Link>
                        <Nav.Link href="#about">About us</Nav.Link>
                        <Nav.Link href="#register">Register</Nav.Link>
                        <Nav.Link href="#donate">Donate</Nav.Link>
                        <Nav.Link href="#contactUs">Contact Us</Nav.Link>
                    </Nav>
                </Navbar.Collapse>
            </Navbar>
                <div className="hungoverhomepageimage" width="100%">
                    <img 
                        src={main} 
                        alt="some poor childrens with company name" 
                        width="100%"/>
                </div>

            <div className="register">
                <div className="register-img">
                    <img src={registerimg} width="70%" height="70%" position="relative" left="0px" alt="register"/>
                    <Button onClick={handleModalBeforeEvent}>Register</Button>{' '}
                </div>
            </div>

            <div className="donate">
                <div className="donate-img">
                    <img src={donateimg} width="70%" height="50%" position="relative" left="0px" alt="donate"/>
                    <Button onClick={handleModalAfterEvent}>Donate</Button>
                </div>
            </div>
            
            <Modal show={show}>

            { !eventBefore ?
            <form onSubmit={DonateFood}>
                <Modal.Dialog>
                    <Modal.Header>
                        <Modal.Title>Donate</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Form.Group>
                            <Form.Label>Name </Form.Label>
                            <Form.Control type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Email </Form.Label>
                            <Form.Control type="email" name="email" required value={email} onChange={e => setEmail(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Contact Number </Form.Label>
                            <Form.Control type="tel" name="contact" required value={contactNumber} onChange={e => setContactNumber(e.target.value)} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of people invited </Form.Label>
                            <Form.Control type="number" name="peopleInvited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of people that turned up </Form.Label>
                            <Form.Control type="number" name="peopleTurnedUp" required value={numberOfGuestAttended} onChange={e => setNumberOfGuestAttended(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of plates ordered </Form.Label>
                            <Form.Control type="number" name="platesOrdered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of plates remaining </Form.Label>
                            <Form.Control type="number" name="platesRemaining" required value={platesLeft} onChange={e => setPlatesLeft(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Type of food </Form.Label>
                            <br />
                            <input type="radio" id="non-veg" name="typeOfFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
                            <label htmlFor="non-veg">Non-Veg</label>
                            <br />
                            <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
                            <label htmlFor="veg">Veg</label>
                        </Form.Group>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button top="100px" variant="primary" type="submit" value="Submit">Submit</Button>{' '}
                        <Button variant="secondary" onClick={e => setShow(false)}>Close</Button>
                    </Modal.Footer>
                </Modal.Dialog>
            </form>

            :  
            
            <form onSubmit={RegisterEvent}>
                <Modal.Dialog>
                    <Modal.Header>
                        <Modal.Title>Register</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <Form.Group>
                            <Form.Label>Name</Form.Label>
                            <Form.Control type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Email</Form.Label>
                            <Form.Control type="email" name="email" required value={email} onChange={e => setEmail(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Contact Number </Form.Label>
                            <Form.Control type="tel" name="contact" required value={contactNumber} onChange={e => setContactNumber(e.target.value)} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of people invited </Form.Label>
                            <Form.Control type="number" name="peopleInvited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Date of the event</Form.Label>
                            <Form.Control type="date" name="date" required value={dateOfEvent} onChange={e => setDateOfEvent(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Start Time </Form.Label>
                            <Form.Control type="time" name="startTime" required value={startTimeOfEvent} onChange={e => setStartTimeOfEvent(e.target.value)} />
                            <Form.Label>End Time </Form.Label>
                            <Form.Control type="time" name="endTime" required value={endTimeOfEvent} onChange={e => setEndTimeOfEvent(e.target.value)} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Number of plates ordered </Form.Label>
                            <Form.Control type="number" name="platesOrdered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Type of food </Form.Label>
                            <br />
                            <input type="radio" id="non-veg" name="typeOfFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
                            <label htmlFor="non-veg">Non-Veg</label>
                            <br />
                            <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
                            <label htmlFor="veg">Veg</label>
                        </Form.Group>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button variant="primary" type="submit" value="Submit">Submit</Button>{' '}
                        <Button variant="secondary" onClick={e => setShow(false)}>Close</Button>
                    </Modal.Footer>
            </Modal.Dialog>
        </form>
        
            }
            
            </Modal>
        </div>

    )
}