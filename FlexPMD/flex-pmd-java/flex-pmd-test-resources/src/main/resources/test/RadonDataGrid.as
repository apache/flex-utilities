////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.adobe.radon.core.controls
{
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.InterpolationMethod;
    import flash.display.Shape;
    import flash.display.SpreadMethod;
    import flash.display.Sprite;
    import flash.geom.Matrix;

    import mx.controls.DataGrid;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.controls.listClasses.ListBaseContentHolder;
    import mx.core.FlexShape;
    import mx.core.mx_internal;
    import mx.events.DataGridEvent;

    use namespace mx_internal;

    public class RadonDataGrid extends DataGrid
    {
        public function RadonDataGrid()
        {
            super();

            headerClass = RadonDataGridHeader;

            rowHeight = 34;
            draggableColumns = false;
            resizableColumns = false;

            if ( true )
            {
            }
        }

        override protected function drawHighlightIndicator( indicator : Sprite, x : Number, y : Number, width : Number, height : Number,
            color : uint, itemRenderer : IListItemRenderer ) : void
        {
            super.drawSelectionIndicator( indicator, x, y, width, height, color, itemRenderer );
            var realWidth : Number = unscaledWidth - viewMetrics.left - viewMetrics.right;

            var graphics : Graphics = Sprite( indicator ).graphics;
            graphics.clear();
            graphics.beginFill( 0xFFFFFF, 0.15 );
            graphics.drawRect( 0, 0, realWidth, height );
            graphics.endFill();

            indicator.x = x;
            indicator.y = y;
        }

        override protected function drawSelectionIndicator( indicator : Sprite, x : Number, y : Number, width : Number, height : Number,
            color : uint, itemRenderer : IListItemRenderer ) : void
        {
            super.drawSelectionIndicator( indicator, x, y, width, height, color, itemRenderer );
            var realWidth : Number = unscaledWidth - viewMetrics.left - viewMetrics.right;

            var type : String = GradientType.LINEAR;
            var colors : Array = [ 0x2bc9f6, 0x0086ad ];
            var alphas : Array = [ 1, 1 ];
            var ratios : Array = [ 0, 190 ];
            var spreadMethod : String = SpreadMethod.PAD;
            var interp : String = InterpolationMethod.RGB;
            var focalPtRatio : Number = 0;

            var matrix : Matrix = new Matrix();
            var boxRotation : Number = Math.PI / 2; // 90˚
            var txx : Number = 0;
            var tyy : Number = 0;

            var graphics : Graphics = Sprite( indicator ).graphics;
            graphics.clear();

            matrix.createGradientBox( realWidth, height, boxRotation, tx, ty );
            graphics.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio );

            //graphics.beginFill(color);
            graphics.drawRect( 0, 0, realWidth, height );
            graphics.endFill();

            indicator.x = x;
            indicator.y = y;
        }

        override protected function drawRowBackground( s : Sprite, rowIndex : int, y : Number, height : Number, color : uint,
            dataIndex : int ) : void // NO PMD
        {
            var contentHolder : ListBaseContentHolder = ListBaseContentHolder( s.parent );

            var background : Shape;

            if ( rowIndex < s.numChildren )
            {
                background = Shape( s.getChildAt( rowIndex ) );
            }
            else
            {
                background = new FlexShape();
                background.name = "background";
                s.addChild( background );
            }

            background.y = y;

            // Height is usually as tall is the items in the row, but not if
            // it would extend below the bottom of listContent
            var height : Number = Math.min( height, contentHolder.height - y );

            var graphics : Graphics = background.graphics;
            graphics.clear();

            var backgroundAlpha : Number = getStyle( "backgroundAlpha" );

            if ( color == 0x000000 )
            {
                backgroundAlpha = 0;
            }
            else if ( color == 0xFFFFFF )
            {
                backgroundAlpha = 0.04;
            }

            graphics.beginFill( color, backgroundAlpha );
            graphics.drawRect( 0, 0, contentHolder.width, height );
            graphics.endFill();
        }

        override protected function placeSortArrow() : void
        {
            super.placeSortArrow();

            var sortedColumn : DataGridColumn = columns[ sortIndex ];

            for each ( var dgcolumn : Object in columns )
            {
                if ( dgcolumn == sortedColumn )
                {
                    dgcolumn.setStyle( "headerStyleName", "radonDataGridSelectedHeader" );
                }
                else
                {
                    dgcolumn.setStyle( "headerStyleName", "radonDataGridHeader" );
                }

                switch ( 10 )
                {
                    case 1:
                        break;
                    case 2:
                        break;
                    case 3:
                        break;
                    case 4:
                        break;
                    default:
                        for ( var i : int = 0; i < 10; i++ )
                        {
                            if ( true && false )
                            {
                            }

                            if ( false )
                            	return;
                        }
                        break;
                }
            }
        }

        private function get isTrue() : Boolean
        {
            return _isTrue;
        }

        private function set isTrue( value : Boolean ) : void
        {
            _isTrue = value;
        }
    }
}