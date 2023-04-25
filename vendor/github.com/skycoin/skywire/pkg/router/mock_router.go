// Code generated by mockery v2.14.1. DO NOT EDIT.

package router

import (
	context "context"

	cipher "github.com/skycoin/skywire-utilities/pkg/cipher"

	mock "github.com/stretchr/testify/mock"

	net "net"

	routing "github.com/skycoin/skywire/pkg/routing"
)

// MockRouter is an autogenerated mock type for the Router type
type MockRouter struct {
	mock.Mock
}

// AcceptRoutes provides a mock function with given fields: _a0
func (_m *MockRouter) AcceptRoutes(_a0 context.Context) (net.Conn, error) {
	ret := _m.Called(_a0)

	var r0 net.Conn
	if rf, ok := ret.Get(0).(func(context.Context) net.Conn); ok {
		r0 = rf(_a0)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(net.Conn)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(context.Context) error); ok {
		r1 = rf(_a0)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// Close provides a mock function with given fields:
func (_m *MockRouter) Close() error {
	ret := _m.Called()

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// DelRules provides a mock function with given fields: _a0
func (_m *MockRouter) DelRules(_a0 []routing.RouteID) {
	_m.Called(_a0)
}

// DialRoutes provides a mock function with given fields: ctx, rPK, lPort, rPort, opts
func (_m *MockRouter) DialRoutes(ctx context.Context, rPK cipher.PubKey, lPort routing.Port, rPort routing.Port, opts *DialOptions) (net.Conn, error) {
	ret := _m.Called(ctx, rPK, lPort, rPort, opts)

	var r0 net.Conn
	if rf, ok := ret.Get(0).(func(context.Context, cipher.PubKey, routing.Port, routing.Port, *DialOptions) net.Conn); ok {
		r0 = rf(ctx, rPK, lPort, rPort, opts)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(net.Conn)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(context.Context, cipher.PubKey, routing.Port, routing.Port, *DialOptions) error); ok {
		r1 = rf(ctx, rPK, lPort, rPort, opts)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// IntroduceRules provides a mock function with given fields: rules
func (_m *MockRouter) IntroduceRules(rules routing.EdgeRules) error {
	ret := _m.Called(rules)

	var r0 error
	if rf, ok := ret.Get(0).(func(routing.EdgeRules) error); ok {
		r0 = rf(rules)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// PingRoute provides a mock function with given fields: ctx, rPK, lPort, rPort, opts
func (_m *MockRouter) PingRoute(ctx context.Context, rPK cipher.PubKey, lPort routing.Port, rPort routing.Port, opts *DialOptions) (net.Conn, error) {
	ret := _m.Called(ctx, rPK, lPort, rPort, opts)

	var r0 net.Conn
	if rf, ok := ret.Get(0).(func(context.Context, cipher.PubKey, routing.Port, routing.Port, *DialOptions) net.Conn); ok {
		r0 = rf(ctx, rPK, lPort, rPort, opts)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(net.Conn)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(context.Context, cipher.PubKey, routing.Port, routing.Port, *DialOptions) error); ok {
		r1 = rf(ctx, rPK, lPort, rPort, opts)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// ReserveKeys provides a mock function with given fields: n
func (_m *MockRouter) ReserveKeys(n int) ([]routing.RouteID, error) {
	ret := _m.Called(n)

	var r0 []routing.RouteID
	if rf, ok := ret.Get(0).(func(int) []routing.RouteID); ok {
		r0 = rf(n)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]routing.RouteID)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(int) error); ok {
		r1 = rf(n)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// RoutesCount provides a mock function with given fields:
func (_m *MockRouter) RoutesCount() int {
	ret := _m.Called()

	var r0 int
	if rf, ok := ret.Get(0).(func() int); ok {
		r0 = rf()
	} else {
		r0 = ret.Get(0).(int)
	}

	return r0
}

// Rule provides a mock function with given fields: _a0
func (_m *MockRouter) Rule(_a0 routing.RouteID) (routing.Rule, error) {
	ret := _m.Called(_a0)

	var r0 routing.Rule
	if rf, ok := ret.Get(0).(func(routing.RouteID) routing.Rule); ok {
		r0 = rf(_a0)
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(routing.Rule)
		}
	}

	var r1 error
	if rf, ok := ret.Get(1).(func(routing.RouteID) error); ok {
		r1 = rf(_a0)
	} else {
		r1 = ret.Error(1)
	}

	return r0, r1
}

// Rules provides a mock function with given fields:
func (_m *MockRouter) Rules() []routing.Rule {
	ret := _m.Called()

	var r0 []routing.Rule
	if rf, ok := ret.Get(0).(func() []routing.Rule); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).([]routing.Rule)
		}
	}

	return r0
}

// SaveRoutingRules provides a mock function with given fields: rules
func (_m *MockRouter) SaveRoutingRules(rules ...routing.Rule) error {
	_va := make([]interface{}, len(rules))
	for _i := range rules {
		_va[_i] = rules[_i]
	}
	var _ca []interface{}
	_ca = append(_ca, _va...)
	ret := _m.Called(_ca...)

	var r0 error
	if rf, ok := ret.Get(0).(func(...routing.Rule) error); ok {
		r0 = rf(rules...)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// SaveRule provides a mock function with given fields: _a0
func (_m *MockRouter) SaveRule(_a0 routing.Rule) error {
	ret := _m.Called(_a0)

	var r0 error
	if rf, ok := ret.Get(0).(func(routing.Rule) error); ok {
		r0 = rf(_a0)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// Serve provides a mock function with given fields: _a0
func (_m *MockRouter) Serve(_a0 context.Context) error {
	ret := _m.Called(_a0)

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context) error); ok {
		r0 = rf(_a0)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// SetupIsTrusted provides a mock function with given fields: _a0
func (_m *MockRouter) SetupIsTrusted(_a0 cipher.PubKey) bool {
	ret := _m.Called(_a0)

	var r0 bool
	if rf, ok := ret.Get(0).(func(cipher.PubKey) bool); ok {
		r0 = rf(_a0)
	} else {
		r0 = ret.Get(0).(bool)
	}

	return r0
}

type mockConstructorTestingTNewMockRouter interface {
	mock.TestingT
	Cleanup(func())
}

// NewMockRouter creates a new instance of MockRouter. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
func NewMockRouter(t mockConstructorTestingTNewMockRouter) *MockRouter {
	mock := &MockRouter{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}